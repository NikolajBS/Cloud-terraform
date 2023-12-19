output "host_name" {
  value = google_secret_manager_secret.database_host_secret.name
}
output "database_host_secret" {
  value = google_secret_manager_secret_version.database_host_secret_version
}
####
output "database_username_name" {
  value = google_secret_manager_secret.database_username_secret.name
}
output "database_username_secret" {
  value = google_secret_manager_secret_version.database_username_secret_version
}
####
output "database_password_name" {
  value = google_secret_manager_secret.database_password_secret.name
}
output "database_password_secret" {
  value = google_secret_manager_secret_version.database_password_secret_version
}
####
output "database_name" {
  value = google_secret_manager_secret.database_name_secret.name
}
output "database_name_secret" {
  value = google_secret_manager_secret_version.database_name_secret_version
}
####
output "database_port_name" {
  value = google_secret_manager_secret.database_port_secret.name
}
output "database_port_secret" {
  value = google_secret_manager_secret_version.database_port_secret_version
}