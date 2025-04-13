locals {
prefix = "databricks-imdb"
  tags = {
    Environment = "Dev"
    Owner = "wikar8998@gmail.com"
  }
}

resource "azurerm_databricks_workspace" "this" {
  name                        = "${local.prefix}-workspace"
  resource_group_name         = var.resource_group.name
  location                    = var.resource_group.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-workspace-rg"
  tags                        = local.tags
}