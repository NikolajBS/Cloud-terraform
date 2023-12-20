resource "google_cloud_run_v2_service" "default" {
  name     = "cloud-bite-backend"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  project  = var.project
  
  depends_on = [var.cloud_run_api, var.sql_admin_api]
  template {
    
    scaling {
      min_instance_count = 1
      max_instance_count = 5
    }
    
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.db_instance_name]
      }
    }
  
    containers {
      image = "gcr.io/cloud-handin-project/backend-img:latest"
        
        env {
          name  = "DATABASE_HOST"
          value_source {
            secret_key_ref {
              secret = var.host_name
              version = var.database_host_secret.version
          } 
        }
        }
        env {
          name  = "DATABASE_USERNAME"
          value_source {
            secret_key_ref {
              secret = var.database_username_name
              version = var.database_username_secret.version
          } 
        }
        }
         env {
          name  = "DATABASE_PASSWORD"
          value_source {
            secret_key_ref {
              secret = var.database_password_name
              version = var.database_password_secret.version
          } 
        }
         }

         env {
          name  = "DATABASE_NAME"
          value_source {
            secret_key_ref {
              secret = var.database_name
              version = var.database_name_secret.version
          } 
        }
         }
         env {
          name = "DATABASE_PORT"
          value_source {
            secret_key_ref {
              secret = var.database_port_name
              version = var.database_port_secret.version
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
      connector = var.vpc_run_connection
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


