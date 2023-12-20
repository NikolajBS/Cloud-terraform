resource "google_sql_database_instance" "instance" {
  name             = "cloudrun-sql"
  region           = var.region
  database_version = "MYSQL_8_0"
  
  depends_on = [ var.vpc_network_connection ]
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_network
      enable_private_path_for_google_cloud_services = true
    }
  }
  deletion_protection = var.sql_deletion_protection
}

resource "google_sql_database" "my_database" {
  name     = var.DB_NAME
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "my_user" {
  name     = var.DB_USER
  instance = google_sql_database_instance.instance.name
  password = var.DB_PASSWORD
}

