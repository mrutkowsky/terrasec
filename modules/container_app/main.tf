locals {
  name    = var.container_app_name
  env_id  = var.container_app_environment_id
  rg_name = var.resource_group_name
  ingress = var.ingress
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

  ingress {
    external_enabled           = local.ingress.external_enabled
    target_port                = local.ingress.target_port
    exposed_port               = local.ingress.exposed_port
    transport                  = local.ingress.transport
    allow_insecure_connections = local.ingress.allow_insecure_connections
    traffic_weight {
      revision_suffix = local.ingress.traffic_weight.revision_suffix
      label      = local.ingress.traffic_weight.label
      percentage = local.ingress.traffic_weight.percentage
    }
  }
}