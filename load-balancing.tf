resource "google_compute_global_forwarding_rule" "http" {
  provider              = google-beta
  project               = var.project
  name                  = "http-rule"
  target                = google_compute_target_http_proxy.default.self_link
  ip_address            = google_compute_global_address.external.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_global_address" "external" {
  project    = var.project
  name       = "external"
  ip_version = "IPV4"
}

resource "google_compute_target_http_proxy" "default" {
  project  = var.project
  name     = "l7-xlb-target-http-proxy"
  provider = google-beta
  url_map  = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  project         = var.project
  name            = "l7-xlb-url-map"
  provider        = google-beta
  default_service = google_compute_backend_bucket.frontend_bucket_backend.self_link
}

# template for backend bucket
resource "google_compute_instance_template" "instance_template" {
  name         = "my-instance-template"
  machine_type = "f1-micro"

  disk {
    source_image = "projects/cloud-handin-project/global/images/image-balance"  # Change to your image
  }

  network_interface {
    network = "default"
  }
}

# service
resource "google_compute_backend_service" "backend_service" {
  name        = "backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = google_compute_instance_group_manager.instance_group.instance_group
  }
  health_checks = [google_compute_health_check.health_check.self_link]
}