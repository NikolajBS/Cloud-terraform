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

# part of vpc
data "google_compute_zones" "this" {
  region  = var.region
  project = var.project_id
}

locals {
  type   = ["public", "private"]
  zones = data.google_compute_zones.this.names
}

# VPC
resource "google_compute_network" "this" {
  name = "${var.name}-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

# Subnets for vpc
resource "google_compute_subnetwork" "this" {
  count                   = length(locals.type)
  name                    = "${var.name}-subnet-${local.type[count.index]}"
  ip_cidr_range           = local.type[count.index] == "public" ? "10.0.1.0/24" : "10.0.2.0/24"
  network                 = google_compute_network.this.id
  region                  = var.region
  private_ip_google_access = local.type[count.index] == "private" ? true : false
}

# Firewall rules for vpc
resource "google_compute_firewall" "this" {
  name    = "${var.name}-firewall"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"] 
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

