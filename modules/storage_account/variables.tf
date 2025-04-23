variable "sa_name" {
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

variable "account_tier" {
  description = "Tier of the storage account (Standard or Premium)"
  type        = string
}

variable "account_replication_type" {
  description = "Replication type of the storage account (LRS, GRS, RA-GRS, etc.)"
  type        = string
}

variable "network_rules" {
  description = "Network rules for the storage account"
  type = object({
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = {
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}