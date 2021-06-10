module "az-keyvault" {
  source = "../modules/terraform-azurerm-keyvault"

  # Resource Group Variables

  #create_az_rg   = false
  az_rg_name     = module.az-resource-group.az-rg-name
  az_rg_location = module.az-resource-group.az-rg-location

  # Key vault Variables 
  az_kv_name     = "test-kv"
  az_kv_sku_name = "standard"

  az_kv_purge_protection_enabled   = false
  az_kv_soft_delete_retention_days = 7

  depends_on = [module.az-resource-group]

  az_net_acls = {
    bypass                     = "None"
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  az_tags = {
    Environment   = "Development"
    CostCenter    = "Department"
    ResourceOwner = "Example Owner"
    Project       = "Project Name"
    Role          = "Resource Group"
  }
}

  # if below settings are used, please ensure storage account for logs has been created
  az_kv_ds_enable_logs_to_storage = true
  az_kv_ds_storage_account_id     = module.az-storage-account-for-logs.az-sa-id

  az_kv_ds_enable_logs_to_log_analytics_ws = true
  az_kv_ds_log_analytics_ws_id             = module.az-log-analytics.az-la-ws-id
}