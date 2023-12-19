# VPC network
resource "google_compute_network" "this" {
  name = "${var.name}-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

# create an ip address
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.this.id
}
# Subnets for vpc
resource "google_compute_subnetwork" "this" {
  name                    = "test1234"
  ip_cidr_range           = "10.0.2.0/28"
  network                 = google_compute_network.this.id
  region                  = var.region
  private_ip_google_access = true
}
resource "google_service_networking_connection" "private_connection" {
  network                 = google_compute_network.this.name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
  
  depends_on = [google_compute_network.this, google_vpc_access_connector.connector]
}

resource "google_vpc_access_connector" "connector" {
  name          = "run-vpc"
  subnet {
    name = google_compute_subnetwork.this.name
  }
  machine_type = "e2-standard-4"
  min_instances = 2
  max_instances = 3
  region        = var.region
}