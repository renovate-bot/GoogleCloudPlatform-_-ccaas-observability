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

resource "google_monitoring_dashboard" "df_playbook" {
  dashboard_json = <<EOF
{
  "displayName": "DialogFlow Playbook Monitoring",
  "mosaicLayout": {
    "columns": 48,
    "tiles": [
      {
        "height": 16,
        "width": 24,
        "widget": {
          "title": "Playbook Intent",
          "timeSeriesTable": {
            "columnSettings": [
              {
                "column": "Metric"
              },
              {
                "column": "df_bot_name",
                "visible": true
              },
              {
                "column": "value"
              },
              {
                "column": "df_intent"
              }
            ],
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "timeSeriesQuery": {
                  "outputFullDuration": true,
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": [
                        "metric.label.\"df_intent\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/df_playbook\" resource.type=\"global\""
                  }
                }
              }
            ],
            "metricVisualization": "NUMBER"
          }
        }
      },
      {
        "xPos": 24,
        "height": 16,
        "width": 24,
        "widget": {
          "title": "Recent Playbook Activity",
          "timeSeriesTable": {
            "columnSettings": [
              {
                "column": "df_playbook_name",
                "visible": true
              },
              {
                "column": "monitored_resource_container"
              },
              {
                "column": "project_id"
              },
              {
                "column": "df_intent",
                "visible": true
              },
              {
                "column": "df_language",
                "visible": true
              },
              {
                "column": "log"
              },
              {
                "column": "value"
              },
              {
                "column": "Metric"
              },
              {
                "column": "df_bot_name"
              },
              {
                "column": "df_bot_env",
                "visible": true
              },
              {
                "column": "df_bot_version",
                "visible": true
              }
            ],
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "timeSeriesQuery": {
                  "outputFullDuration": true,
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/df_playbook\" resource.type=\"global\""
                  }
                }
              }
            ],
            "metricVisualization": "NUMBER"
          }
        }
      },
      {
        "yPos": 16,
        "height": 16,
        "width": 24,
        "widget": {
          "title": "Playbook Calls",
          "xyChart": {
            "chartOptions": {
              "mode": "STATS"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_50",
                      "groupByFields": [
                        "metric.label.\"df_bot_env\"",
                        "metric.label.\"df_bot_name\"",
                        "metric.label.\"df_bot_version\"",
                        "metric.label.\"log\"",
                        "metric.label.\"df_language\"",
                        "metric.label.\"df_intent\"",
                        "metric.label.\"df_playbook_name\"",
                        "resource.label.\"project_id\"",
                        "resource.label.\"monitored_resource_container\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/df_playbook\" resource.type=\"global\""
                  }
                }
              }
            ],

            "yAxis": {
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 16,
        "xPos": 24,
        "height": 16,
        "width": 24,
        "widget": {
          "title": "Playbooks by Name",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"df_playbook_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/df_playbook\" resource.type=\"global\""
                  }
                }
              }
            ],

            "yAxis": {
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 32,
        "height": 16,
        "width": 24,
        "widget": {
          "title": "Quota Usage",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_MAX",
                      "groupByFields": [
                        "metric.label.\"method\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"serviceruntime.googleapis.com/quota/rate/net_usage\" resource.type=\"consumer_quota\""
                  }
                }
              }
            ],

            "yAxis": {
              "scale": "LINEAR"
            }
          }
        }
      }
    ]
  }
}
EOF
}

resource "google_monitoring_dashboard" "df" {
  dashboard_json = <<EOF
{
  "displayName": "DialogFlow CX Monitoring",
  "mosaicLayout": {
    "columns": 48,
    "tiles": [
      {
        "height": 16,
        "width": 24,
        "widget": {
          "title": "Intent Labels",
          "timeSeriesTable": {
            "columnSettings": [
              {
                "displayName": "DF Intent Name",
                "column": "df_intent_name",
                "visible": true
              },
              {
                "column": "value",
                "visible": true
              }
            ],
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "timeSeriesQuery": {
                  "outputFullDuration": true,
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"df_intent_name\""
                      ],
                      "perSeriesAligner": "ALIGN_SUM"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/df_flow\"",
                    "secondaryAggregation": {
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"df_intent_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    }
                  }
                }
              }
            ],
            "metricVisualization": "NUMBER"
          }
        }
      },
      {
        "xPos": 24,
        "height": 16,
        "width": 24,
        "widget": {
          "title": "Flow Names",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metric.label.\"df_flow_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/df_flow\""
                  }
                }
              }
            ],

            "yAxis": {
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "yPos": 16,
        "height": 16,
        "width": 24,
        "widget": {
          "title": "Sentiment Score",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_PERCENTILE_95",
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/df_sentiment_score\""
                  }
                }
              }
            ],

            "timeshiftDuration": "3600s",
            "yAxis": {
              "scale": "LINEAR"
            }
          }
        }
      }
    ]
  }
}
EOF
}