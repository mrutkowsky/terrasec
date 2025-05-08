variable "container_app_name" {
  description = "The name of the Container App."
  type        = string
}

variable "container_app_environment_id" {
  description = "The ID of the Container App Environment."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created."
  type        = string
}

variable "ingress" {
  description = "The ingress configuration for the Container App."
  type = object({
    external_enabled           = bool
    target_port                = number
    exposed_port               = optional(number)
    transport                  = string
    allow_insecure_connections = bool
    traffic_weight = object({
      revision_suffix = string
      percentage      = number
    })
  })
  default = {
    external_enabled           = false
    target_port                = 80
    exposed_port               = 80
    transport                  = "tcp"
    allow_insecure_connections = false
    traffic_weight = {
      revision_suffix = "1"
      percentage      = 100
    }
  }
}