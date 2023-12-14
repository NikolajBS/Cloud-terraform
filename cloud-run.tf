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
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret.database_host_secret.name
              version = google_secret_manager_secret_version.database_host_secret_version.version
          } 
        }
        }
        env {
          name  = "DATABASE_USERNAME"
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret.database_username_secret.name
              version = google_secret_manager_secret_version.database_username_secret_version.version
          } 
        }
        }
         env {
          name  = "DATABASE_PASSWORD"
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret.database_password_secret.name
              version = google_secret_manager_secret_version.database_password_secret_version.version
          } 
        }
         }

         env {
          name  = "DATABASE_NAME"
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret.database_name_secret.name
              version = google_secret_manager_secret_version.database_name_secret_version.version
          } 
        }
         }
         env {
          name = "DATABASE_PORT"
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret.database_port_secret.name
              version = google_secret_manager_secret_version.database_port_secret_version.version
          } 
        }
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
