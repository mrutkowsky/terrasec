variable "sql_server_name" {
  description = "Name of the sql server"
  type        = string
}

variable "location" {
  description = "Azure region where the sql server will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the sql server"
  type        = map(string)
  default     = {}
}
