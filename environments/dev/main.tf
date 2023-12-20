provider "google" {
  credentials = file(var.gcp_svc_key)
  project = var.project
  region = var.region
}
module "secrets" {
  source = "../../modules/secrets"
  DB_USER = var.DB_USER
  DB_NAME = var.DB_NAME
  DB_PASSWORD = var.DB_PASSWORD
  DB_PORT = var.DB_PORT
  db_private_ip = module.cloud_sql.db_private_ip
}
module "buckets" {
  source = "../../modules/buckets"
  project = var.project
}
module "networking" {
  source = "../../modules/networking"
  name = var.name
  region = var.region
}
module "cloud_sql" {
  source = "../../modules/cloud_sql"
  region = var.region
  DB_USER = var.DB_USER
  DB_NAME = var.DB_NAME
  DB_PASSWORD = var.DB_PASSWORD
  DB_PORT = var.DB_PORT
  vpc_network = module.networking.network_id
  vpc_network_connection = module.networking.vpc_network_connection
  
}
module "cloud_run" {
  source = "../../modules/cloud_run"
  region = var.region
  project = var.project
  vpc_run_connection = module.networking.vpc_run_connection
  db_instance_name = module.cloud_sql.db_instance_name
  host_name = module.secrets.host_name
  database_host_secret = module.secrets.database_host_secret
  database_username_name = module.secrets.database_username_name
  database_username_secret = module.secrets.database_username_secret
  database_password_name = module.secrets.database_password_name
  database_password_secret = module.secrets.database_password_secret
  database_name = module.secrets.database_name
  database_name_secret = module.secrets.database_name_secret
  database_port_name = module.secrets.database_port_name
  database_port_secret = module.secrets.database_port_secret
  cloud_run_api = module.api.cloud_run_api
  sql_admin_api = module.api.sql_admin_api
}

module "monitoring" {
  source = "../../modules/monitoring"
  project = var.project
  email = var.email
  frontend_bucket_name = module.buckets.frontend_bucket_name
  cloud_run_instance = module.cloud_run.backend_name
  
}
module "api" {
  source = "../../modules/gcp_api"
  project = var.project

}

module "cloud_build" {
  source = "../../modules/cloud_build"
  project = var.project
  cloud_build_api_id = module.api.cloud_api
  backend_address = module.cloud_run.backend_url
  frontend_name = module.buckets.frontend_bucket_name
}
