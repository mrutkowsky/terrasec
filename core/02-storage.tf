module "sa-01" {
  source                   = "../modules/storage_account"
  sa_name                  = "sa0169"
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name
  tags                     = local.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules = {
    default_action = "Deny"
    ip_rules       = []
    virtual_network_subnet_ids = [module.vnet-01.subnet_ids["sub-01"]]
  }
}

resource "azurerm_private_endpoint" "sa-01-private-endpoint" {
  name                = "sa-01-private-endpoint"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet-01.subnet_ids["sub-01"]

  private_service_connection {
    name                           = "sa-01-connection"
    private_connection_resource_id = module.sa-01.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = local.tags
}

resource "azurerm_private_dns_a_record" "sa-01-dns-record" {
  name                = module.sa-01.name
  zone_name           = azurerm_private_dns_zone.pdz_blob.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sa-01-private-endpoint.private_service_connection[0].private_ip_address]
}

module "sa-02" {
  source                   = "../modules/storage_account"
  sa_name                  = "sa026969"
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name
  tags                     = local.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

module "sql-server-01" {
  source              = "../modules/sql_server"
  sql_server_name     = "sql-server-0169"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

module "sql-database-01" {
  source              = "../modules/sql_database"
  sql_database_name   = "sql-database-0169"
  tags                = local.tags
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  server_id           = module.sql-server-01.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 2
  sku_name            = "S0"
  enclave_type        = "Default"

}

resource "azurerm_mssql_virtual_network_rule" "sql_vnet_integration-01" {
  name      = "sql-vnet-rule"
  server_id = module.sql-server-01.id
  subnet_id = module.vnet-01.subnet_ids["sub-02"]
}

resource "azurerm_log_analytics_workspace" "law-01" {
  name                = "law-01"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}