terraform {
  required_providers {
    cyral = {
      source = "cyralinc/cyral"
      version = ">= 2.0.0"
    }
  }
}

provider "cyral" {
  # client_id and client_secret may also be declared as env vars.
  # Please see provider docs for more info.
  client_id = ""
  client_secret = ""
  
  control_plane = "mytenant.cyral.com:8000"
}

resource "cyral_repository" "some_repository" {
  type = "postgresql"
  host = "some-hostname"
  port = "3067"
  name = "terraform-test-repo"
}

module "cyral_repository_config" {
  source = "cyralinc/repository-config/cyral"
  
  repository_id = cyral_repository.some_repository.id

  log_settings = {
    data_activity = {
      DQLs = "LOGGED_FIELDS"
      DMLs = "ALL_REQUESTS"
      DDLs = "ALL_REQUESTS"
    }
    privileged_commands = true
    suspicious_activity = {
      port_scans = true
      authentication_failures = true
      full_scans = true
    }
    policy_violations = true
    connection_activity = true
    sensitive_queries = true
  }
  
  advanced = {
    redact_literal_values = true
    enhance_database_logs = true
    alert_on_policy_violations = true
    enable_preconfigured_alerts = true
    perform_filter_analysis = true
    block_on_violations = true
    rewrite_queries_on_violations = true
  }
}

output "repository_conf_analysis_id" {
  value = module.cyral_repository_config.repository_conf_analysis_id
}