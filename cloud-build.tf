resource "google_cloudbuild_trigger" "cloud-bite-backend" {
  name = "cloud-bite-backend"

  trigger_template {
    branch_name = "main"
    repo_name   = "Cloud-backend"
  }

  filename = "backendPipeline.yml"
}

resource "google_cloudbuild_trigger" "cloud-bite-frontend" {
  name = "cloud-bite-frontend"

  trigger_template {
    branch_name = "main"
    repo_name   = "Cloud-frontend"
  }

  substitutions = {
    FRONTEND_BUCKET_NAME = google_storage_bucket.cloud_bite_frontend.name
  }
# add backend config address as a substitutions and use it in pipeline build
  filename = "frontendPipeline.yml"
}
