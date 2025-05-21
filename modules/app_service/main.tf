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
  tags                = local.tags
  service_plan_id     = local.service_plan_id
  app_settings        = local.app_settings

  client_certificate_enabled = false

  https_only = false

  site_config {
    always_on                               = false                 # ❌ Aplikacja może być wyłączana przy bezczynności
    ftps_state                              = "AllAllowed"          # ❌ Zezwolenie na niezaszyfrowane połączenia FTP
    http2_enabled                           = false                 # ❌ Wyłączenie HTTP/2
    websockets_enabled                      = true                  # ❌ Potencjalne nadużycia przez WebSockets
    use_32_bit_worker                       = true                  # ❌ Ograniczenia wydajności i bezpieczeństwa
    container_registry_use_managed_identity = false                 # ❌ Brak uwierzytelnienia przy pobieraniu obrazów kontenera

    # ip_restriction {
    #   action = "Allow" # ❌ brak restrykcji IP
    # }

    ip_restriction_default_action = "Allow" # ❌ brak restrykcji IP
    minimum_tls_version           = "1.1"   # ❌ brak wymuszenia TLS 1.2
    scm_minimum_tls_version       = "1.1"   # ❌ brak wymuszenia TLS 1.2
    vnet_route_all_enabled        = false
  }

  auth_settings {
    enabled                       = true
    unauthenticated_client_action = "AllowAnonymous" # ❌ brak wymuszenia uwierzytelnienia
  }

  # ❌ Brak tożsamości zarządzanej
  # identity {
  # }

}