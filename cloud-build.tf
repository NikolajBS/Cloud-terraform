resource "google_cloudbuild_trigger" "cloud_backend_trigger" {
  name     = "cloud-backend-trigger"
  project  = var.project
  filename = "backendPipeline.yml" 
  depends_on = [ google_project_service.cloud_build_api ]
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
  depends_on = [ google_project_service.cloud_build_api]

  github {
    owner     = "NikolajBS"
    name      = "Cloud-frontend"
    push {
      branch = "main"
    }
  }

  substitutions = {
    _BACKEND_ADDRESS     = data.google_cloud_run_service.backend.status[0].url
    _FRONTEND_BUCKET_NAME = google_storage_bucket.cloud_bite_frontend.name
  }
}
