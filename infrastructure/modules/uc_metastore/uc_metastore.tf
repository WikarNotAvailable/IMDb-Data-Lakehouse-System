terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.74.0"
    }
  }
}

locals {
  tags = {
    Owner = "wikar8998@gmail.com"
  }
}

data "azuread_client_config" "current" {}

resource "azurerm_storage_account" "metastorage" {
  name                     = "storageaccimdbmetastore"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "metastore" {
  storage_account_id    = azurerm_storage_account.metastorage.id
  name                  = "metastore"
  container_access_type = "private"
}

resource "azurerm_role_assignment" "metastorecontributor" {
  scope                = azurerm_storage_account.metastorage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.metastore_connector_principal_id
}

resource "databricks_metastore" "imdbmetastore" {
  name = "imdb_metastore"
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.metastore.name,
  azurerm_storage_account.metastorage.name)
  owner         = "uc admins"
  region        = var.resource_group.location
  force_destroy = true
}

resource "databricks_metastore_assignment" "imdbworkspaceassignment" {
  metastore_id = databricks_metastore.imdbmetastore.id
  workspace_id = var.databricks_workspace_id
}