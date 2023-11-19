resource "google_project_service" "cloud_build_api" {
  project = var.project
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "networking_api" {
  project = var.project
  service = "servicenetworking.googleapis.com"
}

resource "google_project_service" "compute_engine_api" {
  project = var.project
  service = "compute.googleapis.com"
}

resource "google_project_service" "cloud_run_api" {
  project = var.project
  service = "run.googleapis.com"
}

resource "google_project_service" "sql_admin_api" {
  project = var.project
  service = "sqladmin.googleapis.com"
}