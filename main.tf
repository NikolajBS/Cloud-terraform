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
  credentials = file(var.gcp_svc_key)
  project = var.project
  region = var.region
}

# resource "google_storage_bucket" "tf-backend" {
#   name          = "cloud-handin-bucket-gcp"
#   force_destroy = false
#   location      = "EU"
#   storage_class = "STANDARD"
#   versioning {
#     enabled = true
#   }
#   public_access_prevention = "enforced"
# }

