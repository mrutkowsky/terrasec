locals {
  as_01_app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"     = "1"
    "WEBSITE_NODE_DEFAULT_VERSION" = "14"
  }
}

module "asp-01" {
  source                = "../modules/app_service_plan"
  app_service_plan_name = "asp-01"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = local.location
  sku_name              = "B1"
  os_type               = "Linux"
}

module "as-01" {
  source              = "../modules/app_service"
  app_service_name    = "as-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  app_settings        = local.as_01_app_settings
  service_plan_id     = module.asp-01.id
  tags                = local.tags
}

module "as-02" {
  source              = "../modules/app_service"
  app_service_name    = "as-02"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  app_settings        = local.as_01_app_settings
  service_plan_id     = module.asp-01.id
  tags                = local.tags
}

module "as-03" {
  source              = "../modules/app_service"
  app_service_name    = "as-03"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  app_settings        = local.as_01_app_settings
  service_plan_id     = module.asp-01.id
  tags                = local.tags
}

module "cae-01" {
  source                     = "../modules/container_app_environment"
  container_app_env_name     = "cae-01"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = local.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law-01.id
  infrastructure_subnet_id    = module.vnet-01.subnet_ids["sub-01"]

}

module "ca-01" {
  source                       = "../modules/container_app"
  container_app_name           = "ca-01"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = module.cae-01.id
  ingress = {
    external_enabled           = false
    target_port                = 80
    exposed_port               = 80
    transport                  = "tcp"
    allow_insecure_connections = false
    traffic_weight = {
      revision_suffix = "1"
      percentage = 100
    }
  }
}

module "ca-02" {
  source                       = "../modules/container_app"
  container_app_name           = "ca-02"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = module.cae-01.id
  ingress = {
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"
    allow_insecure_connections = true
    traffic_weight = {
      revision_suffix = "1"
      percentage = 100
    }
  }
}

module "ca-03" {
  source                       = "../modules/container_app"
  container_app_name           = "ca-03"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = module.cae-01.id
  ingress = {
    external_enabled           = true
    target_port                = 80
    transport                  = "auto"
    allow_insecure_connections = true
    traffic_weight = {
      revision_suffix = "1"
      percentage = 100
    }
  }
}

resource "azurerm_network_interface" "nic-01" {
  name                = "nic-01"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet-01.subnet_ids["sub-01"]
    private_ip_address_allocation = "Dynamic"
  }
}

module "vm-01" {
  source              = "../modules/virtual_machine"
  name             = "vm-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  network_interface_ids = [azurerm_network_interface.nic-01.id]
  size = "Standard_B1s"
}