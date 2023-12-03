
resource "google_logging_project_sink" "my_log_sink" {
  name        = "my-log-sink"
  project     = var.project
  destination = "bigquery.googleapis.com/projects/${var.project}/datasets/logs"
  filter      = "severity >= ERROR"
}

resource "google_monitoring_alert_policy" "my_alert_policy" {
  display_name = "My Alert Policy"
  combiner     = "OR"
  conditions {
    display_name = "High Latency on Cloud Run"
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

resource "google_monitoring_notification_channel" "example" {
  display_name = "My Notification Channel"
  type         = "email"

  labels = {
    email_address = "math-351@hotmail.com"
  }

  project = var.project
}