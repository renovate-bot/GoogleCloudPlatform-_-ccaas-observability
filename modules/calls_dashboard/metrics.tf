/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_logging_metric" "calls_failed" {
  name = "ccaas_calls_failed"

  bucket_name = "projects/${var.project_id}/locations/${var.log_bucket.location}/buckets/${var.log_bucket.name}"
  description = "Number of failed calls in the last minute."
  filter      = <<-EOT
    resource.type="contactcenteraiplatform.googleapis.com/ContactCenter"
    textPayload:"[Call] Call failed due to an error."
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }

  project = var.project_id
}

resource "google_logging_metric" "calls_established" {
  name = "ccaas_calls_established"

  bucket_name = "projects/${var.project_id}/locations/${var.log_bucket.location}/buckets/${var.log_bucket.name}"
  description = "Number of established calls in the last minute."
  filter      = <<-EOT
    resource.type="contactcenteraiplatform.googleapis.com/ContactCenter"
    textPayload:"[Call] Call connected successfully."
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }

  project = var.project_id
}

resource "google_logging_metric" "calls_successful" {
  name = "ccaas_calls_successful"

  bucket_name = "projects/${var.project_id}/locations/${var.log_bucket.location}/buckets/${var.log_bucket.name}"
  description = "Number of successful calls in the last minute."
  filter      = <<-EOT
    resource.type="contactcenteraiplatform.googleapis.com/ContactCenter"
    textPayload:"[Call] Call finished successfully."
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }

  project = var.project_id
}

resource "google_logging_metric" "voice_platform_errors" {
  name = "ccaas_voice_platform_errors"

  bucket_name = "projects/${var.project_id}/locations/${var.log_bucket.location}/buckets/${var.log_bucket.name}"
  description = "Number of voice platform errors in the last minute."
  filter      = <<-EOT
    resource.type="contactcenteraiplatform.googleapis.com/ContactCenter"
    textPayload:"error in the voice platform"
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }

  project = var.project_id
}

resource "google_logging_metric" "stream_errors" {
  name = "ccaas_stream_errors"

  bucket_name = "projects/${var.project_id}/locations/${var.log_bucket.location}/buckets/${var.log_bucket.name}"
  description = "Number of stream errors in the last minute."
  filter      = <<-EOT
    resource.type="contactcenteraiplatform.googleapis.com/ContactCenter"
    textPayload:"An error occurred in stream"
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }

  project = var.project_id
}