output "key_vault_uri" {
  value     = azurerm_key_vault.vault.vault_uri
  sensitive = true
}

output "key_vault_resource_id" {
  value = azurerm_key_vault.vault.id
}