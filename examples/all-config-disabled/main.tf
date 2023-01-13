terraform {
  required_providers {
    cyral = {
      source = "cyralinc/cyral"
      version = ">= 4.0.0"
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
  name = "terraform-test-repo"

  repo_node {
    host = "some-hostname"
    port = "3067"
  }
}

module "cyral_repository_config" {
  source = "cyralinc/repository-config/cyral"
  
  repository_id = cyral_repository.some_repository.id

  log_settings = {
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

output "repository_conf_analysis_id" {
  value = module.cyral_repository_config.repository_conf_analysis_id
}