locals {
  app_service_name    = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_settings        = var.app_settings
  tags                = var.tags
  service_plan_id     = var.service_plan_id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
resource "azurerm_linux_web_app" "web_app" {
  name                = local.app_service_name
  resource_group_name = local.resource_group_name
  location            = local.location
  service_plan_id     = local.service_plan_id

  site_config {
    always_on = true
  }

  app_settings = local.app_settings
}