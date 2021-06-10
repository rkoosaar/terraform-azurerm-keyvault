# Local Declarations

locals {
  az_rg_name     = element(coalescelist(data.azurerm_resource_group.az-rg-create.*.name, azurerm_resource_group.az-rg.*.name, [""]), 0)
  az_rg_location = element(coalescelist(data.azurerm_resource_group.az-rg-create.*.location, azurerm_resource_group.az-rg.*.location, [""]), 0)
  default_tags   = {}
  all_tags       = merge(local.default_tags, var.az_tags)

  # Default network ACLs if not defined in module. 
  default_net_acls = {
    bypass                     = "None"
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

# Resource Group (Create or Select)

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "az-rg-create" {
  count = var.create_az_rg == false ? 1 : 0
  name  = var.az_rg_name
}

resource "azurerm_resource_group" "az-rg" {
  count    = var.create_az_rg ? 1 : 0
  name     = var.az_rg_name
  location = var.az_rg_location
}

# Create Keyvault

resource "random_integer" "az_kv_num" {
  min = 1000
  max = 9999
}

resource "azurerm_key_vault" "az-kv" {
  name                = "${lower(var.az_kv_name)}${random_integer.az_kv_num.result}"
  resource_group_name = local.az_rg_name
  location            = local.az_rg_location
  sku_name            = var.az_kv_sku_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enabled_for_deployment          = var.az_kv_enabled_for_deployment
  enabled_for_disk_encryption     = var.az_kv_enabled_for_disk_encryption
  enabled_for_template_deployment = var.az_kv_enabled_for_template_deployment
  enable_rbac_authorization       = var.az_kv_enable_rbac_authorization

  purge_protection_enabled = var.az_kv_purge_protection_enabled
  # This field can only be configured one time and cannot be updated.
  soft_delete_retention_days = var.az_kv_soft_delete_retention_days

  # Network ACLs
  dynamic "network_acls" {
    for_each = var.az_net_acls != null ? tolist([var.az_net_acls]) : [local.default_net_acls]
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  tags = local.all_tags
}

# Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "az-kv-self-ap" {
  key_vault_id = azurerm_key_vault.az-kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  certificate_permissions = ["backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "restore", "setissuers", "update"]
  key_permissions         = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
  secret_permissions      = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]

  lifecycle {
    create_before_destroy = true
  }
}
# Key Vault diagnostic settings (logs)

resource "azurerm_monitor_diagnostic_setting" "az-kv-ds-storage-account" {
  count              = var.az_kv_ds_enable_logs_to_storage ? 1 : 0
  name               = "logs-to-storage-account"
  target_resource_id = azurerm_key_vault.az-kv.id
  storage_account_id = var.az_kv_ds_storage_account_id

  log {
    category = "AuditEvent"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "az-kv-ds-log-analytics-ws" {
  count                      = var.az_kv_ds_enable_logs_to_log_analytics_ws ? 1 : 0
  name                       = "logs-to-log-analytics-ws"
  target_resource_id         = azurerm_key_vault.az-kv.id
  log_analytics_workspace_id = var.az_kv_ds_log_analytics_ws_id

  log {
    category = "AuditEvent"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}