output "network_id" {
  value = google_compute_network.this.id
}

output "vpc_network_connection" {
  value = google_service_networking_connection.private_connection
}

output "vpc_run_connection" {
  value = google_vpc_access_connector.connector.id
}