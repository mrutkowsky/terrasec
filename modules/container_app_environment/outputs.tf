output "id" {
    description = "The ID of the Container App Environment."
    value       = azurerm_container_app_environment.cae.id
}

output "container_app_environment_name" {
    description = "The name of the Container App Environment."
    value       = azurerm_container_app_environment.cae.name
}

output "container_app_environment_location" {
    description = "The location of the Container App Environment."
    value       = azurerm_container_app_environment.cae.location
}

output "container_app_environment_default_domain" {
    description = "The default domain of the Container App Environment."
    value       = azurerm_container_app_environment.cae.default_domain
}