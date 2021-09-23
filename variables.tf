variable "repository_id" {
  type        = string
  description = ""//TODO
}

variable "log_settings" {
  type = object({
    everything = bool
    data_activity = object({
      DQLs = string
      DMLs = string
      DDLs = string
    })
    privileged_commands = bool
    suspicious_activity = object({
      port_scans = bool
      authentication_failures = bool
      full_scans = bool
    })
    policy_violations = bool
    connection_activity = bool
    sensitive_queries = bool
  })
  description = ""//TODO
}

variable "advanced" {
  type = object({
    redact_literal_values = bool
    enhance_database_logs = bool
    alert_on_policy_violations = bool
    enable_preconfigured_alerts = bool
    perform_filter_analysis = bool
    block_on_violations = bool
    rewrite_queries_on_violations = bool
  })
  description = ""//TODO
}
