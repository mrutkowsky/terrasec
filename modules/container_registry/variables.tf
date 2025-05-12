variable "location" {
    description = "The location where the Azure Container Registry will be created."
    type        = string
}

variable "acr_name" {
    description = "The name of the Azure Container Registry."
    type        = string
}

variable "resource_group_name" {
    description = "The name of the resource group in which to create the Azure Container Registry."
    type        = string
}

variable "sku" {
    description = "The SKU of the Azure Container Registry (e.g., Basic, Standard, Premium)."
    type        = string
}

variable "admin_enabled" {
    description = "Specifies whether the admin user is enabled for the Azure Container Registry."
    type        = bool
}

variable "tags" {
    description = "A mapping of tags to assign to the resource."
    type        = map(string)
}