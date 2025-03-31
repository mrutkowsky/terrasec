module "vnet" {
  source              = "../../modules/virtual_network"
  vnet_name           = "my-vnet"
  location            = "westeurope"
  resource_group_name = "my-resource-group"
  address_space       = ["10.0.0.0/16"]
  
  subnets = {
    subnet1 = {
      name           = "subnet1"
      address_prefix = "10.0.1.0/24"
    }
    subnet2 = {
      name           = "subnet2"
      address_prefix = "10.0.2.0/24"
    }
  }
  
  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}