data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                       = "imdb-key-vault"
  location                   = var.resource_group.location
  resource_group_name        = var.resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = 90
}

resource "azurerm_key_vault_access_policy" "vault_access_policies" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  certificate_permissions = var.certificate_permissions
}

resource "azurerm_key_vault_secret" "app_password" {
  name         = "imdb-app-password"
  value        = var.app_password
  key_vault_id = azurerm_key_vault.vault.id
}