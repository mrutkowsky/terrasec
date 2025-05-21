locals {
  as_01_app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "0"                                                                         # ❌ brak readonly deployment = możliwość modyfikacji na żywo
    DEBUG_MODE               = "true"                                                                      # ❌ pozostawiony tryb debugowania
    ALLOW_ALL_ORIGINS        = "*"                                                                         # ❌ brak kontroli CORS
    STORAGE_CONNECTION       = "DefaultEndpointsProtocol=http;AccountName=plain;AccountKey=plaintextkey==" # ❌ wrażliwe dane w konfiguracji
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

resource "azurerm_private_endpoint" "pe_as_01" {
  name                = "pe-as-01"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet-01.subnet_ids["sub-01"]

  private_service_connection {
    name                           = "connection-as-01"
    private_connection_resource_id = module.as-01.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_dns_a_record" "pdz_a_record_as" {
  name                = "as-01"
  zone_name           = azurerm_private_dns_zone.pdz_as.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pe_as_01.private_service_connection[0].private_ip_address]
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

resource "azurerm_private_endpoint" "pe_as_02" {
  name                = "pe-as-02"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet-01.subnet_ids["sub-01"]

  private_service_connection {
    name                           = "connection-as-02"
    private_connection_resource_id = module.as-02.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_dns_a_record" "pdz_a_record_as_02" {
  name                = "as-02"
  zone_name           = azurerm_private_dns_zone.pdz_as.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pe_as_02.private_service_connection[0].private_ip_address]
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

module "acr" {
  source                = "../modules/container_registry"
  acr_name              = "acr01332"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = local.location
  sku                   = "Standard"
  admin_enabled         = true
  tags                  = local.tags
  
}


module "cae-01" {
  source                     = "../modules/container_app_environment"
  container_app_env_name     = "cae-01"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = local.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law-01.id
  infrastructure_subnet_id   = module.vnet-01.subnet_ids["sub-01"]

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
      percentage      = 100
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
      percentage      = 100
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
      percentage      = 100
    }
  }
}

resource "azurerm_network_interface" "nic-01" {
  name                = "nic-01"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet-01.subnet_ids["sub-03"]
    private_ip_address_allocation = "Dynamic"
  }
}

module "vm-01" {
  source                = "../modules/virtual_machine"
  name                  = "vm-01"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = local.location
  network_interface_ids = [azurerm_network_interface.nic-01.id]
  size                  = "Standard_B1s"
}