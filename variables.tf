variable "repository_id" {
  description = "ID of the repository that will have its configuration managed"
  type        = string
}

variable "log_settings" {
  description = "Repository log settings as shown in the UI tab 'Log Settings'"
  type = object({
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
  default = {
    data_activity = {
      DQLs = ""
      DMLs = ""
      DDLs = ""
    }
    privileged_commands = false
    suspicious_activity = {
      port_scans = false
      authentication_failures = false
      full_scans = false
    }
    policy_violations = false
    connection_activity = false
    sensitive_queries = false
  }
  validation {
    condition     = alltrue([for k, v in var.log_settings.data_activity : 
      v == "" || v == "ALL_REQUESTS" || v == "LOGGED_FIELDS"])
    error_message = "The data_activity options must have one of the following values: \"ALL_REQUEST\", \"LOGGED_FIELDS\" or \"\"."
  }
}

variable "advanced" {
  description = "Repository advanced settings as shown in the UI tab 'Advanced'"
  type = object({
    redact_literal_values = bool
    enhance_database_logs = bool
    alert_on_policy_violations = bool
    enable_preconfigured_alerts = bool
    perform_filter_analysis = bool
    enable_data_masking = bool
    block_on_violations = bool
    rewrite_queries_on_violations = bool
  })
  default = {
    redact_literal_values = true
    enhance_database_logs = false
    alert_on_policy_violations = true
    enable_preconfigured_alerts = true
    perform_filter_analysis = true
    enable_data_masking = false
    block_on_violations = false
    rewrite_queries_on_violations = false
  }
}
