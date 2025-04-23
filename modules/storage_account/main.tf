locals {
  location                 = var.location
  name                     = var.sa_name
  resource_group_name      = var.resource_group_name
  tags                     = var.tags
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  network_rules            = var.network_rules
}

resource "azurerm_storage_account" "sa" {
  name                     = local.name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = local.account_tier
  account_replication_type = local.account_replication_type

  tags = local.tags

  network_rules {
  default_action             = local.network_rules.default_action
  ip_rules                   = local.network_rules.ip_rules
  virtual_network_subnet_ids = local.network_rules.virtual_network_subnet_ids
  }
}