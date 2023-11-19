resource "google_cloud_run_v2_service" "default" {
  name     = "cloud-bite-backend"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
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
      }
    }

    containers {
      image = "gcr.io/cloud-bite-sdu-final/cloud-bite-backend-zbg:latest"

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
