variable "gcp_svc_key" {
  type        = string
  description = "Service account key for Google Cloud Platform"
}

variable "project" {
  type        = string
  description = "Google Cloud Project ID"
}

variable "region" {
  type        = string
  description = "Google Cloud region"
  default = "europe-north1"
}
variable "DB_USER" {
  type = string
}

variable "DB_NAME" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}

variable "DB_PORT" {
  
}
variable "email" {
  
}

variable "name" {
  type           = string
  description  = "Production vpc network"
  default       = "production"
}

variable "sql_deletion_protection" {
  type = bool
  default = true
}