resource "google_storage_bucket" "cloud_bite_frontend" {
  name          = "cloud-bite-frontend-gpc"
  force_destroy = true
  location      = "EU"
  storage_class = "STANDARD"
  
  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
  }
  
}


resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.cloud_bite_frontend.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}


resource "google_compute_backend_bucket" "frontend_bucket_backend" {
  project     = var.project
  name        = "frontend-bucket-backend"
  description = "Serves frontend through HTTP"
  bucket_name = google_storage_bucket.cloud_bite_frontend.name
  enable_cdn  = true
}

resource "google_compute_global_address" "website_ip" {
  name = "website-lb-ip"
}

data "google_dns_managed_zone" "dns_zone" {
  name = "group8-dev"  
}

resource "google_dns_record_set" "group8_frontend" {
  name       = data.google_dns_managed_zone.dns_zone.dns_name
  type       = "A"
  ttl        = 300
  managed_zone = data.google_dns_managed_zone.dns_zone.name
  rrdatas    = [google_compute_global_address.website_ip.address]
}

resource "google_compute_url_map" "website" {
  name            = "website-url-map"
  default_service = google_compute_backend_bucket.frontend_bucket_backend.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name        = "allpaths"
    default_service = google_compute_backend_bucket.frontend_bucket_backend.self_link
  }
}

resource "google_compute_target_https_proxy" "website-proxy" {
  provider = google
  name    = "website-target-proxy"
  url_map = google_compute_url_map.website.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.website.self_link]
}

resource "google_compute_global_forwarding_rule" "default" {
  provider = google
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website_ip.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.website-proxy.self_link
}

resource "google_compute_managed_ssl_certificate" "website" {
  project = var.project
  provider = google-beta
  name = "website-cert"
  managed {
    domains = [ google_dns_record_set.group8_frontend.name ]
  }
}
