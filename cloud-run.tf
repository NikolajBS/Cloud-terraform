resource "google_cloud_run_v2_service" "default" {
  name     = "cloud-bite-backend"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  project  = var.project
  
  depends_on = [google_project_service.cloud_run_api, google_project_service.sql_admin_api]
  template {
    
    scaling {
      min_instance_count = 1
      max_instance_count = 5
    }
    
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.instance.connection_name]
      }
    }
  
    containers {
      image = "gcr.io/cloud-handin-project/backend-img:latest"
        
        env {
          name  = "DATABASE_HOST"
          value = google_secret_manager_secret_version.database_host_secret_version.secret_data
        }
        env {
          name  = "DATABASE_USERNAME"
          value = google_secret_manager_secret_version.database_username_secret_version.secret_data
        }
         env {
          name  = "DATABASE_PASSWORD"
          value = google_secret_manager_secret_version.database_password_secret_version.secret_data
         }

         env {
          name  = "DATABASE_NAME"
          value = google_secret_manager_secret_version.database_name_secret_version.secret_data
         }
         env {
          name = "DATABASE_PORT"
          value = google_secret_manager_secret_version.database_port_secret_version.secret_data
         }
      ports {
        container_port = 3000
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
    }
    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress = "ALL_TRAFFIC"
      
    }
  }
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_service_iam_member" "unauthorized_access" {
  service = google_cloud_run_v2_service.default.name
  location = var.region
  project  = var.project

  role    = "roles/run.invoker"
  member  = "allUsers"
}

data "google_cloud_run_service" "backend" {
  name     = google_cloud_run_v2_service.default.name
  location = var.region
  project  = var.project
}

output "backend_url" {
  value = data.google_cloud_run_service.backend.status[0].url
}

## below could be removed
resource "google_storage_bucket" "gcs-bucket" {
  name     = "logging-bucket-gcp-cloud-run"
  location = "EU"
}

resource "google_logging_project_sink" "instance-sink" {
  name        = "my-instance-sink"
  description = "some explanation on what this is"
  destination = "storage.googleapis.com/${google_storage_bucket.gcs-bucket.name}"
  filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${google_cloud_run_v2_service.default.name}\""

  unique_writer_identity = true
}
