# Cyral Repository Configuration Module

This module provides the repository configuration options as shown in Cyral UI.

## Usage
```terraform
terraform {
  required_providers {
    cyral = {
      source = "cyralinc/cyral"
      version = ">= 2.8.0"
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
    enable_data_masking = true
    block_on_violations = true
    rewrite_queries_on_violations = true
  }
}

output "repository_conf_analysis_id" {
  value = module.cyral_repository_config.repository_conf_analysis_id
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cyral"></a> [cyral](#requirement\_cyral) | >= 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cyral"></a> [cyral](#provider\_cyral) | >= 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cyral_repository_conf_analysis.this](https://registry.terraform.io/providers/cyralinc/cyral/latest/docs/resources/repository_conf_analysis) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advanced"></a> [advanced](#input\_advanced) | Repository advanced settings as shown in the UI tab 'Advanced' | <pre>object({<br>    redact_literal_values = bool<br>    enhance_database_logs = bool<br>    alert_on_policy_violations = bool<br>    enable_preconfigured_alerts = bool<br>    perform_filter_analysis = bool<br>    enable_data_masking = bool<br>    block_on_violations = bool<br>    rewrite_queries_on_violations = bool<br>  })</pre> | <pre>{<br>  "alert_on_policy_violations": true,<br>  "block_on_violations": false,<br>  "enable_data_masking": false,<br>  "enable_preconfigured_alerts": true,<br>  "enhance_database_logs": false,<br>  "perform_filter_analysis": true,<br>  "redact_literal_values": true,<br>  "rewrite_queries_on_violations": false<br>}</pre> | no |
| <a name="input_log_settings"></a> [log\_settings](#input\_log\_settings) | Repository log settings as shown in the UI tab 'Log Settings' | <pre>object({<br>    data_activity = object({<br>      DQLs = string<br>      DMLs = string<br>      DDLs = string<br>    })<br>    privileged_commands = bool<br>    suspicious_activity = object({<br>      port_scans = bool<br>      authentication_failures = bool<br>      full_scans = bool<br>    })<br>    policy_violations = bool<br>    connection_activity = bool<br>    sensitive_queries = bool<br>  })</pre> | <pre>{<br>  "connection_activity": false,<br>  "data_activity": {<br>    "DDLs": "",<br>    "DMLs": "",<br>    "DQLs": ""<br>  },<br>  "policy_violations": false,<br>  "privileged_commands": false,<br>  "sensitive_queries": false,<br>  "suspicious_activity": {<br>    "authentication_failures": false,<br>    "full_scans": false,<br>    "port_scans": false<br>  }<br>}</pre> | no |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | ID of the repository that will have its configuration managed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_conf_analysis_id"></a> [repository\_conf\_analysis\_id](#output\_repository\_conf\_analysis\_id) | The ID of the repository analysis configuration resource. |
