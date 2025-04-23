output "id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.sa.id
}

output "name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.sa.name
}

output "primary_endpoint" {
  description = "The primary endpoint of the storage account."
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

output "primary_access_key" {
  description = "The primary access key for the storage account."
  value       = azurerm_storage_account.sa.primary_access_key
  sensitive   = true
}