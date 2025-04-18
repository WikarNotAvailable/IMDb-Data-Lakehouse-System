data "azuread_client_config" "current" {}

data "azuread_user" "me" {
  user_principal_name = "wikar8998@gmail.com"  
}

resource "azuread_application_registration" "imdbapp" {
  display_name     = "imdb-app"
  description      = "IMDb Data Lakehouse application"
  sign_in_audience = "AzureADMyOrg"  
}

resource "azuread_service_principal" "example" {
  client_id                    = azuread_application.example.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id, data.azuread_user.me.object_id]
}