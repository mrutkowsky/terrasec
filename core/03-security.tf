module "kv-01" {
  source              = "../modules/key_vault"
  kv_name             = "kv-0169"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
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