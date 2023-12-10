resource "google_logging_project_sink" "cloud_run_log_sink" {
  name        = "cloud-run-log-sink"
  project     = var.project
  destination = "bigquery.googleapis.com/projects/${var.project}/datasets/cloud_run_logs"
  filter      = "resource.type=\"cloud_run_revision\""
}


resource "google_logging_project_sink" "frontend_log_sink" {
  name        = "frontend-log-sink"
  project     = var.project
  destination = "bigquery.googleapis.com/projects/${var.project}/datasets/frontend_logs"
  filter      = "resource.type=\"gcs_bucket\" AND protoPayload.serviceName=\"storage.googleapis.com/storage\" AND resource.labels.bucket_name=\"cloud-bite-frontend-gcp\""
}

resource "google_bigquery_dataset" "frontend_logs_dataset" {
  dataset_id = "frontend_logs"  # Use the same dataset name as in the logging sink
  project    = var.project
  location   = "EU"  # Update with your desired location
}

# this alert will send a mail whenever the traffic exceeds the treshold value of 1
# Alert policy for high error rate in Cloud Run
resource "google_monitoring_alert_policy" "cloud_run_error_alert_policy" {
  display_name = "Cloud Run Error Rate Alert"
  combiner = "OR"
  conditions {
    display_name = "High Error Rate on Cloud Run"
    condition_threshold {
      filter           = "metric.type=\"run.googleapis.com/request_count\" AND resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${google_cloud_run_v2_service.default.name}\""
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
      filter           = "metric.type=\"storage.googleapis.com/storage/object_count\" AND resource.type=\"gcs_bucket\" AND resource.labels.bucket_name=\"${google_storage_bucket.cloud_bite_frontend.name}\""
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


