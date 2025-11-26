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

resource "google_logging_metric" "df_flows" {
  name = "df_flow"

  filter = <<-EOT
    resource.type="global"
    jsonPayload.queryResult.currentFlow.displayName:*
  EOT

  label_extractors = {
    "df_agent_state"   = "EXTRACT(jsonPayload.queryResult.currentPage.displayName)"
    "df_flow_name"     = "EXTRACT(jsonPayload.queryResult.currentFlow.displayName)"
    "df_intent_name"   = "EXTRACT(jsonPayload.queryResult.intent.displayName)"
    "df_language_code" = "EXTRACT(jsonPayload.queryResult.languageCode)"
  }

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"

    labels {
      key        = "df_flow_name"
      value_type = "STRING"
    }
    labels {
      key        = "df_intent_name"
      value_type = "STRING"
    }
    labels {
      description = "DF Agent State"
      key         = "df_agent_state"
      value_type  = "STRING"
    }
    labels {
      description = "DF Language Code"
      key         = "df_language_code"
      value_type  = "STRING"
    }

  }

  project = var.project_id
}

resource "google_logging_metric" "df_playbooks" {
  name = "df_playbook"

  description = "DialogFlow Playbook"
  filter      = <<-EOT
    resource.type="global"
    jsonPayload.pageInfo.displayName:*
  EOT

  label_extractors = {
    "df_bot_env"       = "EXTRACT(jsonPayload.sessionInfo.parameters.bot.environment)"
    "df_bot_name"      = "EXTRACT(jsonPayload.sessionInfo.parameters.bot.name)"
    "df_bot_version"   = "EXTRACT(jsonPayload.sessionInfo.parameters.bot.version)"
    "df_intent"        = "EXTRACT(jsonPayload.intentInfo.displayName)"
    "df_language"      = "EXTRACT(jsonPayload.languageCode)"
    "df_playbook_name" = "EXTRACT(jsonPayload.pageInfo.displayName)"
  }


  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    labels {
      key        = "df_bot_name"
      value_type = "STRING"

    }
    labels {
      description = "Bot Environment"
      key         = "df_bot_env"
      value_type  = "STRING"
    }
    labels {
      description = "Bot Version"
      key         = "df_bot_version"
      value_type  = "STRING"
    }
    labels {
      description = "Intent"
      key         = "df_intent"
      value_type  = "STRING"
    }
    labels {
      description = "Language"
      key         = "df_language"
      value_type  = "STRING"
    }
    labels {
      description = "Playbook Name"
      key         = "df_playbook_name"
      value_type  = "STRING"
    }

  }

  project = var.project_id
}

resource "google_logging_metric" "df_sentiment_scores" {
  name = "df_sentiment_score"

  description     = "DF Sentiment Score"
  filter          = <<-EOT
    resource.type="global"
    jsonPayload.queryResult.currentFlow.displayName:*
  EOT
  value_extractor = "EXTRACT(jsonPayload.queryResult.sentimentAnalysisResult.score)"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "DISTRIBUTION"
  }

  bucket_options {
    exponential_buckets {
      growth_factor      = 2
      num_finite_buckets = 64
      scale              = 0.01
    }
  }

  project = var.project_id
}