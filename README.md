# terraform-azurerm-keyvault

Terraform module for creating and managing Azure Keyvault resources

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/rkoosaar/terraform-azurerm-keyvault?cacheSeconds=36)](https://github.com/rkoosaar/terraform-azurerm-keyvault/releases/latest)
[![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/rkoosaar/keyvault/azurerm)

## Examples

```
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

  # if below settings are used, please ensure storage account for logs has been created
  az_kv_ds_enable_logs_to_storage = true
  az_kv_ds_storage_account_id     = module.az-storage-account-for-logs.az-sa-id

  az_kv_ds_enable_logs_to_log_analytics_ws = true
  az_kv_ds_log_analytics_ws_id             = module.az-log-analytics.az-la-ws-id
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
| --- | --- |
| terraform | >= 1.0.0 |

## Providers

| Name | Version |
| --- | --- |
| azurerm | >= 2.62.1 |

## Inputs

### Resource Group Variables

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| create\_az\_rg | Boolean flag which if set to true creates a resource group. Defaults to false | `bool` | no  |
| az\_rg\_name | The Name of the Resource Group | `string` | yes |
| az\_rg\_location | The Azure Region where the Resource Group should exist | `string` | yes |

### Key Vault Variables

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| az\_kv\_name | The Name of the Keyvault Account | `string` | yes |
| az\_kv\_sku_name | The Name of the SKU used for this Key Vault. Possible values are standard and premium. Defaults to Standard | `string` | no  |
| az\_kv\_enabled\_for\_deployment | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false | `bool` | no  |
| az\_kv\_enabled\_for\_disk_encryption | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false | `bool` | no  |
| az\_kv\_enabled\_for\_template_deployment | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false | `bool` | no  |
| az\_kv\_enable\_rbac\_authorization | Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false | `bool` | no  |
| az\_kv\_purge\_protection\_enabled | Is Purge Protection enabled for this Key Vault? Defaults to false | `bool` | no  |
| az\_kv\_soft\_delete\_enabled | Should Soft Delete be enabled for this Key Vault? Defaults to false (I have it true, contrary to azure default setting) | `bool` | no  |
| az\_kv\_soft\_delete\_retention_days | The number of days that items should be retained for once soft-deleted, Default is 7 | `number` | no  |
| az_tags | A mapping of tags which should be assigned to all resources | `map` | no  |

#### az\_net\_acls

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| bypass | Bypass specifies which traffic can bypass the network rules, possible values are AzureServices and None | `string` | yes |
| default_action | specifies what to do when no rules match from ip\_rules / virtual\_network\_subnet\_ids. Possible values are Allow and Deny. | `string` | yes |
| ip_rules | List of Allowed IPs | `string list` | yes |
| virtual\_network\_subnet_ids | List of allowed subnet IDs | `string list` | yes |

### Key Vault diagnostic settings (logs)

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| az\_kv\_ds\_enable\_logs\_to\_storage | Enables or Disables saving logs to storage | `bool` | yes |
| az\_kv\_ds\_storage\_account_id | The ID of the Storage Account for Diagnostic Settings | `string` | yes |
| az\_kv\_ds\_enable\_logs\_to\_log\_analytics\_ws | Enables or Disables saving logs to Log Analytics Workspace | `bool` | yes |
| az\_kv\_ds\_log\_analytics\_ws\_id | The ID of the Log Analytics Workspace for Diagnostic Settings | `string` | yes |

## Outputs

| Name | Description |
| --- | --- |
| az-kv-name | Resource azurerm_key_vault name |
| az-kv-id | Resource azurerm_key_vault id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Help

**Got a question?**

File a GitHub [issue](https://github.com/rkoosaar/terraform-azurerm-keyvault/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/rkoosaar/terraform-azurerm-keyvault/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2020 Raiko Koosaar

### Contributors

[![Raiko Koosaar][rkoosaar_avatar]][rkoosaar_homepage]<br/>[Raiko Koosaar][rkoosaar_homepage]

[rkoosaar_homepage]: https://github.com/rkoosaar
[rkoosaar_avatar]: https://github.com/rkoosaar.png?size=150
[github]: https://github.com/rkoosaar
[share_email]: mailto:?subject=terraform-azurerm-keyvault&body=https://github.com/rkoosaar/terraform-azurerm-keyvault
