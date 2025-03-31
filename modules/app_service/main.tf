locals {
    app_service_plan_name = var.app_service_plan_name
    app_service_plan_tier = var.app_service_plan_tier
    app_service_plan_size = var.app_service_plan_size
    app_service_name      = var.app_service_name
    linux_fx_version      = var.linux_fx_version
    app_settings          = var.app_settings
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan
resource "azurerm_service_plan" "asp" {
  name                = local.app_service_plan_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
resource "azurerm_linux_web_app" "example" {
  name                = local.app_service_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}