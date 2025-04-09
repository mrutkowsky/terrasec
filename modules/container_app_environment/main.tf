locals {
    name = var.container_app_env_name
    rg_name = var.resource_group_name
    location = var.location
    log_analytics_workspace_id = var.log_analytics_workspace_id
}

resource "azurerm_container_app_environment" "cae" {
  name                       = local.name
  location                   = local.location
  resource_group_name        = local.rg_name
  log_analytics_workspace_id = local.log_analytics_workspace_id
}