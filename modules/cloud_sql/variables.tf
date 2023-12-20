variable "region" {
  type        = string
  description = "Google Cloud region"
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
variable "vpc_network" {
  
}
variable "vpc_network_connection" {
  
}

variable "sql_deletion_protection" {
  type    = bool
  default = false
}
