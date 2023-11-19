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
    _FRONTEND_BUCKET_NAME = "cloud-bite-frontend-zbg"
  }

  filename = "frontendPipeline.yaml"
}
