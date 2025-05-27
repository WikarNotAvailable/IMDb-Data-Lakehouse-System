output "azure_ad_app_id" {
  value = azuread_application.imdbapp.object_id
}

output "azure_ad_app_password" {
  value     = azuread_application_password.imdbapppass.value
  sensitive = true
}

output "service_principal_id" {
  value = azuread_service_principal.imdbappservprinc.object_id
}