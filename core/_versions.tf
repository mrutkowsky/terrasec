terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25"
    }
  }

  # cloud {
  #   organization = ""

  #   workspaces {
  #     name = ""
  #   }
  # }

  required_version = ">= 1.11.0"
}

provider "azurerm" {
  features {}
}