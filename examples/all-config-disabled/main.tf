terraform {
  required_providers {
    cyral = {
      source = "cyral.com/terraform/cyral" //TODO: point to published provider
    }
  }
}

provider "cyral" {
    client_id = ""
    client_secret = ""
    control_plane = ""
}

resource "cyral_repository" "some_repository" {
  type = "postgresql"
  host = "some-hostname"
  port = "3067"
  name = "terraform-test-repo"
}

module "cyral_repository-config" {
  source = "../../../terraform-cyral-repository-config"
  
  repository_id = cyral_repository.some_repository.id

  log_settings = {
    everything = true
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