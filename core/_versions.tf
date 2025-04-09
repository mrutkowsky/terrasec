terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25"
    }
  }

  cloud {
    organization = "terrasec"

    workspaces {
      name = "terrasec-mgr-01"
    }
  }

  required_version = ">= 1.11.0"
}

provider "azurerm" {
  features {}
}