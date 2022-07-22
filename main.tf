locals {
  map_log_settings_to_log_groups = {
    "privileged_commands" = "privileged"
    "port_scans" = "port-scan"
    "authentication_failures" = "auth-failure"
    "full_scans" = "full-table-scan"
    "policy_violations" = "violations"
    "connection_activity" = "connections"
    "sensitive_queries" = "sensitive"
    "DQLs.ALL_REQUESTS" = "dql"
    "DMLs.ALL_REQUESTS" = "dml"
    "DDLs.ALL_REQUESTS" = "ddl"
    "DQLs.LOGGED_FIELDS" = "sensitive & dql"
    "DMLs.LOGGED_FIELDS" = "sensitive & dml"
    "DDLs.LOGGED_FIELDS" = "sensitive & ddl"
  }

  normal_log_settings_enabled = [for k, v in var.log_settings : k if v == true]
  suspicious_activity_enabled = [for k, v in var.log_settings.suspicious_activity : 
    k if v == true]
  data_activity_enabled = [for k, v in var.log_settings.data_activity : 
    "${k}.${v}" if v == "ALL_REQUESTS" || v == "LOGGED_FIELDS"]
  log_settings_enabled = concat(local.normal_log_settings_enabled, 
    local.suspicious_activity_enabled, local.data_activity_enabled)
  
  log_groups = [ for e in local.log_settings_enabled : 
    local.map_log_settings_to_log_groups[e]]
}


resource "cyral_repository_conf_analysis" "this" {
  repository_id = var.repository_id
  redact = var.advanced.redact_literal_values ? "all" : "none"
  comment_annotation_groups = var.advanced.enhance_database_logs ? [ "identity" ] : []
  alert_on_violation = var.advanced.alert_on_policy_violations
  disable_pre_configured_alerts = !var.advanced.enable_preconfigured_alerts
  block_on_violation = var.advanced.block_on_violations
  disable_filter_analysis = !var.advanced.perform_filter_analysis
  enable_data_masking = var.enable_data_masking
  rewrite_on_violation = var.advanced.rewrite_queries_on_violations
  log_groups = local.log_groups
}