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

  client_certificate_enabled = false

  site_config {
    always_on     = false        # ❌ brak dostępności ciągłej = potencjalne exploity DoS
    ftps_state    = "AllAllowed" # ❌ zezwala na nieszyfrowane FTP (dane uwierzytelniające w plaintext)
    http2_enabled = false

    ip_restriction {
      action = "Allow" # ❌ brak restrykcji IP
    }

    ip_restriction_default_action = "Allow" # ❌ brak restrykcji IP
    minimum_tls_version           = "1.1"   # ❌ brak wymuszenia TLS 1.2
    scm_minimum_tls_version       = "1.1"   # ❌ brak wymuszenia TLS 1.2
    vnet_route_all_enabled        = false
  }

  auth_settings {
    enabled                       = true
    unauthenticated_client_action = "AllowAnonymous" # ❌ brak wymuszenia uwierzytelnienia
  }


  https_only = false

  app_settings = local.app_settings

  tags = {
    environment = "production" # ❌ fałszywa etykieta, która może wprowadzać w błąd
  }
}