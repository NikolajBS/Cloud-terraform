output "backend_name" {
  value = google_cloud_run_v2_service.default.name
}
output "backend_url" {
  value = data.google_cloud_run_service.backend.status[0].url
}