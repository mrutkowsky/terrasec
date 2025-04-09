locals {
  name = var.container_app_name
  env_id = var.container_app_environment_id
  rg_name = var.resource_group_name
}

resource "azurerm_container_app" "ca" {
  name                         = local.name
  container_app_environment_id = local.env_id
  resource_group_name          = local.rg_name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}