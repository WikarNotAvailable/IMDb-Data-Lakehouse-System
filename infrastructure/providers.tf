terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9"
    }
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.74.0"
    }
  }
  cloud {
    organization = "dev-wikar-playground"
    workspaces {
      name = "dev-workspace"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  alias = "databricks_provider_config"
}