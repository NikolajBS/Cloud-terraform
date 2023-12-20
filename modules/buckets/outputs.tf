output "frontend_bucket_name" {
  value = google_storage_bucket.cloud_bite_frontend.name
}

output "reserved-ip" {
  value = google_compute_global_address.website_ip.address
}