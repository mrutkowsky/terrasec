locals {
  location  = "westeurope"
  vnet_name = "vn-01"
  tags = {
    environment = "dev"
  }
}

module "vnet-01" {
  source              = "../modules/virtual_network"
  vnet_name           = local.vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/21", "12.0.0.0/21"]

  subnets = {
    sub-01 = {
      name           = "sub-01"
      address_prefix = ["12.0.1.0/24"]
    }
    sub-02 = {
      name              = "sub-02"
      address_prefix    = ["12.0.2.0/24"]
      service_endpoints = ["Microsoft.Sql"]
    }
    sub-03 = {
      name              = "sub-03"
      address_prefix    = ["10.0.0.0/21"]
      service_endpoints = ["Microsoft.Sql"]
    }
  }

  tags = local.tags
}

resource "azurerm_private_dns_zone" "pdz_as" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdz_vnet_link_as" {
  name                  = "pdz-vnet-link-as-01"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pdz_as.name
  virtual_network_id    = module.vnet-01.id
}

resource "azurerm_private_dns_zone" "pdz_kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdz_vnet_link_kv" {
  name                  = "dnslink-kv-01"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pdz_kv.name
  virtual_network_id    = module.vnet-01.id
}

resource "azurerm_private_dns_zone" "pdz_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdz_vnet_link_blob" {
  name                  = "blob-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pdz_blob.name
  virtual_network_id    = module.vnet-01.id
}