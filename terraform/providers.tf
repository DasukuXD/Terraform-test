provider "azurerm" {
  subscription_id = ""
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.50.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = ""
    container_name       = ""
    storage_account_name = ""
    key                  = ""
  }
}
