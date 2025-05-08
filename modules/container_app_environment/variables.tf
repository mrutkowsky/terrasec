variable "container_app_env_name" {
  description = "The name of the container app environment."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the container app environment will be deployed."
  type        = string
}

variable "location" {
  description = "The Azure region where the container app environment will be deployed."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to be used by the container app environment."
  type        = string
}

variable "infrastructure_subnet_id" {
  type = string
}