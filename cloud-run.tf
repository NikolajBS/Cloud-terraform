resource "google_cloud_run_v2_service" "default" {
   name     = "cloud-bite-backend"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_AND_INTERNAL_ONLY"
  project  = var.project
  
  depends_on = [google_project_service.cloud_run_api, google_project_service.sql_admin_api]

  template {
    scaling {
      max_instance_count = 2
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.instance.connection_name]
        private_database_connection {
          enable_private_ip = true
        }
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
