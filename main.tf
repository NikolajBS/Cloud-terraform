terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.5.0"
    }
  }
  backend "gcs" {
    bucket = "cloud-bite-sdu-final-tf-backend"
  }
}

provider "google" {
  project = var.project
}

resource "google_storage_bucket" "tf-backend" {
  name          = "cloud-bite-sdu-final-tf-backend"
  force_destroy = false
  location      = "EU"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  public_access_prevention = "enforced"
}
