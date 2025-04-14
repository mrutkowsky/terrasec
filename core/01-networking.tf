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
  address_space       = ["10.0.0.0/21"]

  subnets = {
    sub-01 = {
      name           = "sub-01"
      address_prefix = ["10.0.1.0/24"]
    }
    sub-02 = {
      name           = "sub-02"
      address_prefix = ["10.0.2.0/24"]
    }
  }

  tags = local.tags
}