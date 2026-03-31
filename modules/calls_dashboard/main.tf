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

resource "google_monitoring_dashboard" "calls" {
  dashboard_json = <<EOF
{
    "displayName": "Calls Monitoring",
    "mosaicLayout": {
        "columns": 48,
        "tiles": [
            {
                "height": 24,
                "widget": {
                    "title": "CCaaS calls (in 5 min windows)",
                    "xyChart": {
                        "chartOptions": {
                            "mode": "COLOR"
                        },
                        "dataSets": [
                            {
                                "legendTemplate": "Established",
                                "minAlignmentPeriod": "300s",
                                "plotType": "LINE",
                                "targetAxis": "Y1",
                                "timeSeriesQuery": {
                                    "timeSeriesFilter": {
                                        "aggregation": {
                                            "alignmentPeriod": "300s",
                                            "crossSeriesReducer": "REDUCE_SUM",
                                            "perSeriesAligner": "ALIGN_DELTA"
                                        },
                                        "filter": "metric.type=\"logging.googleapis.com/user/ccaas_calls_established_v2\" resource.type=\"logging_bucket\""
                                    }
                                }
                            },
                            {
                                "legendTemplate": "Failed",
                                "minAlignmentPeriod": "300s",
                                "plotType": "LINE",
                                "targetAxis": "Y1",
                                "timeSeriesQuery": {
                                    "timeSeriesFilter": {
                                        "aggregation": {
                                            "alignmentPeriod": "300s",
                                            "crossSeriesReducer": "REDUCE_SUM",
                                            "perSeriesAligner": "ALIGN_DELTA"
                                        },
                                        "filter": "metric.type=\"logging.googleapis.com/user/ccaas_calls_failed_v2\" resource.type=\"logging_bucket\""
                                    }
                                }
                            },
                            {
                                "legendTemplate": "Deflected",
                                "minAlignmentPeriod": "300s",
                                "plotType": "LINE",
                                "targetAxis": "Y1",
                                "timeSeriesQuery": {
                                    "timeSeriesFilter": {
                                        "aggregation": {
                                            "alignmentPeriod": "300s",
                                            "crossSeriesReducer": "REDUCE_SUM",
                                            "perSeriesAligner": "ALIGN_DELTA"
                                        },
                                        "filter": "metric.type=\"logging.googleapis.com/user/ccaas_calls_deflected_v2\" resource.type=\"logging_bucket\""
                                    }
                                }
                            },
                            {
                                "legendTemplate": "Success",
                                "minAlignmentPeriod": "300s",
                                "plotType": "LINE",
                                "targetAxis": "Y1",
                                "timeSeriesQuery": {
                                    "timeSeriesFilter": {
                                        "aggregation": {
                                            "alignmentPeriod": "300s",
                                            "crossSeriesReducer": "REDUCE_SUM",
                                            "perSeriesAligner": "ALIGN_DELTA"
                                        },
                                        "filter": "metric.type=\"logging.googleapis.com/user/ccaas_calls_successful\" resource.type=\"logging_bucket\""
                                    }
                                }
                            },
                            {
                                "legendTemplate": "Stream Errors",
                                "minAlignmentPeriod": "300s",
                                "plotType": "LINE",
                                "targetAxis": "Y1",
                                "timeSeriesQuery": {
                                    "timeSeriesFilter": {
                                        "aggregation": {
                                            "alignmentPeriod": "300s",
                                            "crossSeriesReducer": "REDUCE_SUM",
                                            "perSeriesAligner": "ALIGN_DELTA"
                                        },
                                        "filter": "metric.type=\"logging.googleapis.com/user/ccaas_streaming_errors_v2\" resource.type=\"logging_bucket\""
                                    }
                                }
                            }
                        ],
                        "thresholds": [
                            {
                                "targetAxis": "Y1"
                            }
                        ],
                        "timeshiftDuration": "86400s",
                        "yAxis": {
                            "scale": "LINEAR"
                        }
                    }
                },
                "width": 20
            },
            {
                "height": 8,
                "widget": {
                    "scorecard": {
                        "sparkChartView": {
                            "sparkChartType": "SPARK_BAR"
                        },
                        "timeSeriesQuery": {
                            "outputFullDuration": true,
                            "timeSeriesFilter": {
                                "aggregation": {
                                    "alignmentPeriod": "300s",
                                    "crossSeriesReducer": "REDUCE_SUM",
                                    "perSeriesAligner": "ALIGN_DELTA"
                                },
                                "filter": "metric.type=\"logging.googleapis.com/user/ccaas_calls_established_v2\" resource.type=\"logging_bucket\""
                            }
                        }
                    },
                    "title": "Calls Established (selected interval)"
                },
                "width": 16,
                "xPos": 20
            },
            {
                "height": 8,
                "widget": {
                    "scorecard": {
                        "gaugeView": {
                            "upperBound": ${var.established_call_rate_upper_bound}
                        },
                        "timeSeriesQuery": {
                            "timeSeriesFilter": {
                                "aggregation": {
                                    "alignmentPeriod": "300s",
                                    "crossSeriesReducer": "REDUCE_SUM",
                                    "perSeriesAligner": "ALIGN_SUM"
                                },
                                "filter": "metric.type=\"logging.googleapis.com/user/ccaas_calls_established_v2\" resource.type=\"logging_bucket\""
                            }
                        }
                    },
                    "title": "Current Established Call Rate (5 min window)"
                },
                "width": 16,
                "xPos": 20,
                "yPos": 16
            },
            {
                "height": 8,
                "widget": {
                    "scorecard": {
                        "sparkChartView": {
                            "sparkChartType": "SPARK_BAR"
                        },
                        "thresholds": [
                            {
                                "color": "RED",
                                "direction": "ABOVE",
                                "value": 10
                            },
                            {
                                "color": "RED",
                                "direction": "BELOW",
                                "value": 10
                            }
                        ],
                        "timeSeriesQuery": {
                            "outputFullDuration": true,
                            "timeSeriesFilter": {
                                "aggregation": {
                                    "alignmentPeriod": "300s",
                                    "crossSeriesReducer": "REDUCE_SUM",
                                    "perSeriesAligner": "ALIGN_SUM"
                                },
                                "filter": "metric.type=\"logging.googleapis.com/user/ccaas_calls_failed_v2\" resource.type=\"logging_bucket\""
                            }
                        }
                    },
                    "title": "Calls Failed (selected interval)"
                },
                "width": 16,
                "xPos": 20,
                "yPos": 8
            }
        ]
    }
}
EOF
}