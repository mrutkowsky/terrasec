resource "azurerm_resource_group" "rg" {
  name     = "terrasec"
  location = "West Europe"
}

data "azurerm_client_config" "current" {}
