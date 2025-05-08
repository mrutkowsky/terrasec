module "kv-01" {
  source              = "../modules/key_vault"
  kv_name             = "kv-0169"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  network_acls = {
    bypass                     = "None"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = [module.vnet-01.subnet_ids["sub-01"]]
  }
}

resource "azurerm_private_endpoint" "kv_01" {
  name                = "pe-kv-01"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.vnet-01.subnet_ids["sub-01"]

  private_service_connection {
    name                           = "psc-kv-01"
    private_connection_resource_id = module.kv-01.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}

resource "azurerm_private_dns_a_record" "kv_01" {
  name                = module.kv-01.name
  zone_name           = azurerm_private_dns_zone.pdz_kv.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.kv_01.private_service_connection[0].private_ip_address]
}

module "kv-02" {
  source              = "../modules/key_vault"
  kv_name             = "kv-0269"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}