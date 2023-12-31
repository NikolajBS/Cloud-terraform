resource "google_storage_bucket" "gcs_logging_bucket" {
  name     = "logging-bucket-gcp-cloud-run"
  location = "EU"
}

# Create a logging sink for Cloud Run instance logs
resource "google_logging_project_sink" "instance_log_sink" {
  name        = "cloud-run-sink"
  project     = var.project
  destination = "storage.googleapis.com/${google_storage_bucket.gcs_logging_bucket.name}"
  filter      = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_instance}\""
  unique_writer_identity = true
  
}


# this alert will send a mail whenever the traffic exceeds the treshold value of 1
resource "google_monitoring_alert_policy" "cloud_run_error_alert_policy" {
  display_name = "Cloud Run Error Rate Alert"
  combiner = "OR"
  conditions {
    display_name = "High Error Rate on Cloud Run"
    condition_threshold {
      filter           = "metric.type=\"run.googleapis.com/request_count\" AND resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${var.cloud_run_instance}\""
      threshold_value  = 1
      duration         = "60s"
      comparison       = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.example.id]
}

# Alert policy for high latency on Frontend bucket
resource "google_monitoring_alert_policy" "frontend_health_policy" {
  combiner = "OR"
  display_name = "Frontend Health Check"
  conditions {
    display_name = "High Object Count on Frontend Bucket"
    condition_threshold {
      filter           = "metric.type=\"storage.googleapis.com/storage/object_count\" AND resource.type=\"gcs_bucket\" AND resource.labels.bucket_name=\"${var.frontend_bucket_name}\""
      threshold_value  = 1000  
      duration         = "300s"
      comparison       = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_NONE"  
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.example.id]
}

resource "google_monitoring_notification_channel" "example" {
  display_name = "My Notification Channel"
  type         = "email"

  labels = {
    email_address = var.email
  }

  project = var.project
}
