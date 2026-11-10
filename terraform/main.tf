data "azurerm_client_config" "current" {}

# Key Vault names are globally unique, so add a random suffix
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = local.tags
}

resource "azurerm_key_vault" "main" {
  name                = "kv-${var.project_name}-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Use Azure RBAC instead of legacy access policies
  rbac_authorization_enabled = true

  # Soft delete is always on in Azure; purge protection is off so the
  # demo can be destroyed cleanly. Enable it for real environments.
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Deny public network access by default
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = local.tags
}

locals {
  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}
