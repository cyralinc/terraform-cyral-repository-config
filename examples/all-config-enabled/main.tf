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
    everything = false
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
  
  advanced = {
    redact_literal_values = false
    enhance_database_logs = false
    alert_on_policy_violations = false
    enable_preconfigured_alerts = false
    perform_filter_analysis = false
    block_on_violations = false
    rewrite_queries_on_violations = false
  }
}
