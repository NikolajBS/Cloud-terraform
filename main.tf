terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.5.0"
    }
  }
  backend "gcs" {
    bucket = "cloud-handin-bucket"
  }
}

provider "google" {
  project = var.project
}

resource "google_storage_bucket" "tf-backend" {
  name          = "cloud-handin-bucket"
  force_destroy = false
  location      = "EU"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  public_access_prevention = "enforced"
}
