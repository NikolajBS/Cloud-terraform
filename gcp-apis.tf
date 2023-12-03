resource "google_project_service" "cloud_build_api" {
  project = var.project
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "networking_api" {
  project = var.project
  service = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute_engine_api" {
  project = var.project
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_run_api" {
  project = var.project
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sql_admin_api" {
  project = var.project
  service = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_sql_admin" {
  project = var.project
  service = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage_api" {
  project = var.project
  service = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_apis" {
  project = var.project
  service = "cloudapis.googleapis.com"
  disable_on_destroy = false
}


resource "google_project_service" "stackdriver_logging" {
  project = var.project
  service = "logging.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "error_reporting" {
  project = var.project
  service = "clouderrorreporting.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "monitoring" {
  project = var.project
  service = "monitoring.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "bigquery" {
  project = var.project
  service = "bigquery.googleapis.com"

  disable_on_destroy = false
}