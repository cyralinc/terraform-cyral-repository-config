/* terraform {
  required_providers {
    cyral = {
      source = "cyralinc/cyral"
      version = ">= 1.2.0"//TODO: Should point to the future published version
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