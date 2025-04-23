output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.kv.id
}

output "name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.kv.name
}

output "uri" {
  description = "The URI of the Key Vault for accessing secrets."
  value       = azurerm_key_vault.kv.vault_uri
}
