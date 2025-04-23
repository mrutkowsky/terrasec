locals {
  location            = var.location
  tags                = var.tags
  name                = var.kv_name
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  object_id           = var.object_id
  network_acls        = var.network_acls
}


resource "azurerm_key_vault" "kv" {
  name                        = local.name
  location                    = local.location
  resource_group_name         = local.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = local.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = local.tenant_id
    object_id = local.tenant_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  network_acls {
    bypass          = local.network_acls.bypass
    default_action   = local.network_acls.default_action
    ip_rules         = local.network_acls.ip_rules
    virtual_network_subnet_ids = local.network_acls.virtual_network_subnet_ids
  }
}