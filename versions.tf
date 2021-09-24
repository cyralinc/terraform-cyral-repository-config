/* terraform {
  required_providers {
    cyral = {
      source = "cyralinc/cyral"
      version = ">= 1.3.0"
    }
  }
} */

terraform {
  required_providers {
    cyral = {
      source = "cyral.com/terraform/cyral" //TODO: point to published provider
    }
  }
}