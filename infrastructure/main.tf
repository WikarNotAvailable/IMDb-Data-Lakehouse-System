locals {
  tags = {
    Environment = "Dev"
    Owner       = "wikar8998@gmail.com"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
  tags     = local.tags
}

module "app_registration" {
  source = "./modules/app_registration"
}

module "databricks_workspace" {
  source = "./modules/databricks_workspace"
  resource_group = {
    name     = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
  }
}

module "data_lake_storage" {
  source = "./modules/data_lake_storage"
  resource_group = {
    name     = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
  }
  service_principal_id = module.app_registration.service_principal_id
}

module "key_vault" {
  source = "./modules/key_vault"
  resource_group = {
    name     = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
  }
  app_password = module.app_registration.azure_ad_app_password
}

module "databricks_resources" {
  source = "./modules/databricks_resources"
  resource_id = module.key_vault.key_vault_resource_id
  dns_name = module.key_vault.key_vault_uri
}