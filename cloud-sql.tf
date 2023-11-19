resource "google_sql_database_instance" "instance" {
  name             = "cloudrun-sql"
  region           = var.region
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      authorized_networks {
        name  = "public"
        value = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "my_database" {
  name     = "cloud-bite-database"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "my_user" {
  name     = "cloud-bite-user"
  instance = google_sql_database_instance.instance.name
  password = "cloud-bite-password"
}
