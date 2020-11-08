# Resource Group Variables

variable "create_az_rg" {
  type        = bool
  description = "Boolean flag which if set to true creates a resource group. Defaults to false"
  default     = false
}

variable "az_rg_name" {
  type        = string
  description = "The Name of the Resource Group"
}

variable "az_rg_location" {
  type        = string
  description = "The Azure Region where the Resource Group should exist"
}

# Key Vault Variables

variable "az_kv_name" {
  type        = string
  description = "The Name of the KeyVault Account"
}

variable "az_kv_sku_name" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium"
  default     = "standard"
}

variable "az_kv_enabled_for_deployment" {
  type        = bool
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false"
  default     = false
}

variable "az_kv_enabled_for_disk_encryption" {
  type        = bool
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false"
  default     = false
}

variable "az_kv_enabled_for_template_deployment" {
  type        = bool
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false"
  default     = false
}

variable "az_kv_enable_rbac_authorization" {
  type        = bool
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false"
  default     = false
}

variable "az_kv_purge_protection_enabled" {
  type        = bool
  description = "Is Purge Protection enabled for this Key Vault? Defaults to false"
  default     = false
}

variable "az_kv_soft_delete_enabled" {
  type        = bool
  description = "Should Soft Delete be enabled for this Key Vault? Defaults to false (I have it true, contrary to azure default setting)"
  default     = true
}

variable "az_kv_soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained for once soft-deleted"
  default     = 7
}

variable "az_net_acls" {
  description = "Key Vault network rules. Bypass specifies which traffic can bypass the network rules, possible values are AzureServices and None. default_action specifies what to do when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "az_tags" {
  type        = map
  description = "A mapping of tags which should be assigned to all resources"
  default     = {}
}

# Key Vault diagnostic settings (logs)

variable "az_kv_ds_enable_logs_to_storage" {
  type        = bool
  description = "Enables or Disables saving logs to storage"
  default     = false
}

variable "az_kv_ds_storage_account_id" {
  type        = string
  description = "The ID of the Storage Account for Diagnostic Settings"
  default     = null
}

variable "az_kv_ds_enable_logs_to_log_analytics_ws" {
  type        = bool
  description = "Enables or Disables saving logs to Log Analytics Workspace"
  default     = false
}

variable "az_kv_ds_log_analytics_ws_id" {
  type        = string
  description = "The ID of the Log Analytics Workspace for Diagnostic Settings"
  default     = null
}