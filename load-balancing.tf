# resource "google_compute_global_forwarding_rule" "http" {
#   provider              = google-beta
#   project               = var.project
#   name                  = "http-rule"
#   target                = google_compute_target_http_proxy.default.self_link
#   ip_address            = google_compute_global_address.external.self_link
#   port_range            = "80"
#   load_balancing_scheme = "EXTERNAL_MANAGED"
# }

# resource "google_compute_global_address" "external" {
#   project    = var.project
#   name       = "external"
#   ip_version = "IPV4"
# }

# resource "google_compute_target_http_proxy" "default" {
#   project  = var.project
#   name     = "l7-xlb-target-http-proxy"
#   url_map  = google_compute_url_map.default.id
# }

# resource "google_compute_url_map" "default" {
#   project         = var.project
#   name            = "l7-xlb-url-map"
#   provider        = google-beta
#   default_service = google_compute_backend_bucket.frontend_bucket_backend.self_link
# }

# # template for backend bucket
# resource "google_compute_instance_template" "instance_template" {
#   name         = "my-instance-template"
#   machine_type = "f1-micro"

#   disk {
#     source_image = "projects/cloud-handin-project/global/images/image-balance"  # Change to your image
#   }

#   network_interface {
#     network = "default"
#   }
# }

# # // instance group 
# resource "google_compute_instance_group_manager" "instance_group" {
#   name           = "my-instance-group"
#   base_instance_name = "instance-balance"
#   target_size    = 1  # Set desired target size
#   version {
#     name = "my-version-1"
#     instance_template = google_compute_instance_template.instance_template.self_link
#   }
#   named_port {
#     name = "http"
#     port = 80
#   }
#   zone = "europe-north1-a"
# }

# # health check
# resource "google_compute_health_check" "health_check" {
#   name               = "health-check"
#   check_interval_sec = 10
#   timeout_sec        = 5

#   http_health_check {
#     request_path = "/" # maybe change this to something else
#   }
# }

# // target pool
# resource "google_compute_target_pool" "target_pool" {
#   name = "target-pool"
#   region = "europe-north1"
#   health_checks = [google_compute_health_check.health_check.self_link]
#   instances = ["https://www.googleapis.com/compute/v1/projects/cloud-handin-project/zones/europe-north1-a/instances/instance-balance"]
# }

# # service
# resource "google_compute_backend_service" "backend_service" {
#   name        = "backend-service"
#   port_name   = "http"
#   protocol    = "HTTP"
#   timeout_sec = 10

#   backend {
#     group = google_compute_instance_group_manager.instance_group.instance_group
#   }
#   health_checks = [google_compute_health_check.health_check.self_link]
# }

# # firewall
# resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
#   name       = "global-forwarding-rule"
#   ip_address = google_compute_global_address.external.address
#   port_range = "80"
#   target     = google_compute_target_pool.target_pool.self_link
# }