locals {
  tags = {
    Environment = "Dev"
    Owner = "wikar8998@gmail.com"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
  tags     = local.tags
}