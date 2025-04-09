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

}

module "ca-01" {
  source                     = "../modules/container_app"
  container_app_name         = "ca-01"
  resource_group_name        = azurerm_resource_group.rg.name
  container_app_environment_id = module.cae-01.id
}