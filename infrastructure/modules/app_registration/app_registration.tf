data "azuread_client_config" "current" {}

data "azuread_user" "me" {
  user_principal_name = "wikar8998_gmail.com#EXT#@wikar8998gmail.onmicrosoft.com"
}

resource "azuread_application" "imdbapp" {
  display_name     = "imdb-app"
  description      = "IMDb Data Lakehouse application"
  sign_in_audience = "AzureADMyOrg"
  owners           = [data.azuread_client_config.current.object_id, data.azuread_user.me.object_id]
}

resource "azuread_service_principal" "imdbappservprinc" {
  client_id                    = azuread_application.imdbapp.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id, data.azuread_user.me.object_id]
}

resource "azuread_application_password" "imdbapppass" {
  application_id = azuread_application.imdbapp.id
  end_date       = "2026-04-18T00:00:00Z"
}