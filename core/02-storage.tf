module "sa-01" {
  source                   = "../modules/storage_account"
  sa_name                  = "sa0169"
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name
  tags                     = local.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"

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
  server_id           = module.sql-server-01.sql_server_id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 2
  sku_name            = "S0"
  enclave_type        = "Default"

}

resource "azurerm_log_analytics_workspace" "law-01" {
  name                = "law-01"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}