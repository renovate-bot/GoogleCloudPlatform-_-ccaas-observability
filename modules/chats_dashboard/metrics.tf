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

resource "google_logging_metric" "chats_failed" {
  name = "ccaas_chats_failed"

  bucket_name = "projects/${var.project_id}/locations/${var.log_bucket.location}/buckets/${var.log_bucket.name}"
  description = "Number of failed chats in the last minute."
  filter      = <<-EOT
    resource.type="contactcenteraiplatform.googleapis.com/ContactCenter"
    textPayload:"[Chat] Chat failed."
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }

  project = var.project_id
}

resource "google_logging_metric" "chats_escalated" {
  name = "ccaas_chats_escalated"

  bucket_name = "projects/${var.project_id}/locations/${var.log_bucket.location}/buckets/${var.log_bucket.name}"
  description = "Number of established chats in the last minute."
  filter      = <<-EOT
    resource.type="contactcenteraiplatform.googleapis.com/ContactCenter"
    textPayload:"[Chat] Chat escalation process has been completed."
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }

  project = var.project_id
}

resource "google_logging_metric" "chats_successful" {
  name = "ccaas_chats_successful"

  bucket_name = "projects/${var.project_id}/locations/${var.log_bucket.location}/buckets/${var.log_bucket.name}"
  description = "Number of successful chats in the last minute."
  filter      = <<-EOT
    resource.type="contactcenteraiplatform.googleapis.com/ContactCenter"
    textPayload:"[Chat] Chat has been finished successfully."
  EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }

  project = var.project_id
}