output "db_private_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}

output "db_instance_name" {
  value = google_sql_database_instance.instance.connection_name
}
output "database_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}
