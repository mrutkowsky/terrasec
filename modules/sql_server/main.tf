locals {
  name                = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = local.name
  resource_group_name          = local.resource_group_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "local_admin"
  administrator_login_password = "thisIsKat11$$@#$!"
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "260331@student.pwr.edu.pl"
    object_id      = "374643ec-c525-4fca-89f4-c75326f1f161"
  }

  tags = local.tags
}