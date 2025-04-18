locals {
  tags = {
    Environment = "Dev"
    Owner       = "wikar8998@gmail.com"
  }
}

resource "azurerm_storage_account" "dlstorage" {
  name                     = "storageaccimdbdl"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = local.tags
  is_hns_enabled = true
}

resource "azurerm_storage_container" "bronze" {
  storage_account_id    = azurerm_storage_account.dlstorage.id
  name                  = "bronze"
  container_access_type = "private"
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_id    = azurerm_storage_account.dlstorage.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "gold" {
  name                  = "gold"
  storage_account_id    = azurerm_storage_account.dlstorage.id
  container_access_type = "private"
}