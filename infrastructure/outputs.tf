output "databricks_module" {
  value = module.databricks_workspace
}

output "azure_ad_app_password" {
  value     = module.app_registration.azure_ad_app_password
  sensitive = true
}

output "azure_ad_app_id" {
  value = module.app_registration.azure_ad_app_id
}

output "service_principal_id" {
  value = module.app_registration.service_principal_id
}

output "key_vault_uri" {
  value     = module.key_vault.key_vault_uri
  sensitive = true
}

output "key_vault_resource_id" {
  value = module.key_vault.key_vault_resource_id
}