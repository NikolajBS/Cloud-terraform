
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

# resource "google_dns_managed_zone" "prod" {
#   name     = "prod-zone"
#   dns_name = "prod.mydomain.com."

#   description = "Managed Zone for prod.mydomain.com."

#   visibility = "public"
# }

# resource "google_dns_record_set" "frontend" {
#   name = "www.prod.mydomain.com."
#   type = "CNAME"
#   ttl  = 300

#   managed_zone = google_dns_managed_zone.prod.name

#   rrdatas = [google_storage_bucket.cloud_bite_frontend.self_link]
# }
