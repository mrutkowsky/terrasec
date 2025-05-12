locals {
    location                 = var.location
    acr_name                 = var.acr_name
    resource_group_name      = var.resource_group_name
    sku                      = var.sku
    admin_enabled            = var.admin_enabled
    tags                     = var.tags
}


resource "azurerm_container_registry" "acr" {
    name                = local.acr_name
    resource_group_name = local.resource_group_name
    location            = local.location
    sku                 = local.sku

    network_rule_bypass_option = "AzureServices"

    admin_enabled = local.admin_enabled

    trust_policy_enabled = false
    
    anonymous_pull_enabled = true
}

