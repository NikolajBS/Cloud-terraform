resource "google_secret_manager_secret" "database_host_secret" {
  secret_id = "database-host-secret"
  replication {
    auto {
      
    }
  }
}

resource "google_secret_manager_secret_version" "database_host_secret_version" {
  secret = google_secret_manager_secret.database_host_secret.id
  secret_data = google_sql_database_instance.instance.public_ip_address
}

resource "google_secret_manager_secret" "database_username_secret" {
  
  secret_id = "database-username-secret"
  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "database_username_secret_version" {
  secret = google_secret_manager_secret.database_username_secret.id
  secret_data = var.DB_USER
}

resource "google_secret_manager_secret" "database_password_secret" {
  replication {
    auto {
      
    }
  }
  secret_id = "database-password-secret"
}

resource "google_secret_manager_secret_version" "database_password_secret_version" {
  secret = google_secret_manager_secret.database_password_secret.id
  secret_data = var.DB_PASSWORD
  
}

resource "google_secret_manager_secret" "database_name_secret" {
  replication {
    auto {
      
    }
  }
  secret_id = "database-name-secret"
}

resource "google_secret_manager_secret_version" "database_name_secret_version" {
  secret = google_secret_manager_secret.database_name_secret.id
  secret_data = var.DB_NAME
  
}

resource "google_secret_manager_secret" "database_port_secret" {
  replication {
    auto {
      
    }
  }
  secret_id = "database-port-secret"
}

resource "google_secret_manager_secret_version" "database_port_secret_version" {
  secret = google_secret_manager_secret.database_port_secret.id
  secret_data = var.DB_PORT
  
}