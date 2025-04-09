output "container_app_name" {
    description = "The name of the container app"
    value       = azurerm_container_app.ca.name
}

output "container_app_id" {
    description = "The ID of the container app"
    value       = azurerm_container_app.ca.id
}


output "container_app_location" {
    description = "The location of the container app"
    value       = azurerm_container_app.ca.location
}