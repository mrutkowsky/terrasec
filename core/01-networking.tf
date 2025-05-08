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
      name              = "sub-01"
      address_prefix    = ["12.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
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

resource "azurerm_private_dns_zone" "pdz_sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdz_vnet_link_sql" {
  name                  = "sql-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pdz_sql.name
  virtual_network_id    = module.vnet-01.id
}

resource "azurerm_private_endpoint" "sql-server-01-private-endpoint" {
  name                = "sql-server-01-private-endpoint"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet-01.subnet_ids["sub-01"]

  private_service_connection {
    name                           = "sql-server-01-connection"
    private_connection_resource_id = module.sql-server-01.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  tags = local.tags
}

resource "azurerm_private_dns_a_record" "sql-server-01-dns-record" {
  name                = module.sql-server-01.name
  zone_name           = azurerm_private_dns_zone.pdz_sql.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql-server-01-private-endpoint.private_service_connection[0].private_ip_address]
}

resource "azurerm_private_endpoint" "sql-server-01-private-endpoint-sub-03" {
  name                = "sql-server-01-private-endpoint-sub-03"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet-01.subnet_ids["sub-03"]

  private_service_connection {
    name                           = "sql-server-01-connection-sub-03"
    private_connection_resource_id = module.sql-server-01.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "sql-server-02-private-endpoint-sub-03" {
  name                = "sql-server-02-private-endpoint-sub-03"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet-01.subnet_ids["sub-03"]

  private_service_connection {
    name                           = "sql-server-02-connection-sub-03"
    private_connection_resource_id = module.sql-server-02.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  tags = local.tags
}

resource "azurerm_private_dns_a_record" "sql-server-02-dns-record-sub-03" {
  name                = module.sql-server-02.name
  zone_name           = azurerm_private_dns_zone.pdz_sql.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql-server-02-private-endpoint-sub-03.private_service_connection[0].private_ip_address]
}