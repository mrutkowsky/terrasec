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
      image  = "vulnerables/web-dvwa:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "DB_PASSWORD"
        value = "root" # ❌ słabe hasło w kodzie
      }

      env {
        name  = "DEBUG"
        value = "true" # ❌ tryb debugowania — wyciek stacktrace, configów itp.
      }
    }
  }

  ingress {
    external_enabled           = local.ingress.external_enabled
    target_port                = local.ingress.target_port
    exposed_port               = local.ingress.exposed_port != null ? local.ingress.exposed_port : null
    transport                  = local.ingress.transport
    allow_insecure_connections = local.ingress.allow_insecure_connections
    traffic_weight {
      revision_suffix = local.ingress.traffic_weight.revision_suffix
      percentage      = local.ingress.traffic_weight.percentage
    }
  }
}