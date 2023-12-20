resource "google_cloudbuild_trigger" "cloud_backend_trigger" {
  name     = "cloud-backend-trigger"
  project  = var.project
  filename = "backendPipeline.yml" 
  depends_on = [var.cloud_build_api_id ]
  github {
    owner     = "NikolajBS"
    name      = "Cloud-backend"
    push {
      branch = "main"
    }
  }
}
resource "google_cloudbuild_trigger" "cloud_frontend_trigger" {
  name     = "cloud-frontend-trigger"
  project  = var.project
  filename = "frontendPipeline.yml"  
  depends_on = [ var.cloud_build_api_id]

  github {
    owner     = "NikolajBS"
    name      = "Cloud-frontend"
    push {
      branch = "main"
    }
  }

  substitutions = {
    _BACKEND_ADDRESS     = var.backend_address
    _FRONTEND_BUCKET_NAME = var.frontend_name
  }
}
