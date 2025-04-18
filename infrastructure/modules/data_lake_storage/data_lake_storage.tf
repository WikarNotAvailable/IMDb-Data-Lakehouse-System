locals {
  tags = {
    Environment = "Dev"
    Owner       = "wikar8998@gmail.com"
  }
}

resource "azurerm_storage_account" "dlstorage" {
  name                     = "storageaccountname"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = local.tags
  is_hns_enabled = true
}