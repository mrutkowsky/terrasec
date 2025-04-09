variable "kv_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "location" {
  description = "Azure region where the virtual network will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the virtual network"
  type        = map(string)
  default     = {}
}

variable "tenant_id" {
  description = "Tenant ID of the Azure subscription"
  type        = string
}

variable "object_id" {
  description = "Object ID of the Azure subscription"
  type        = string
}