output "metastore_connector_principal_id" {
  value = azurerm_databricks_access_connector.imdbmetastoreconnector.identity[0].principal_id
}

output "datalake_connector_principal_id" {
  value = azurerm_databricks_access_connector.imdbdlconnector.identity[0].principal_id
}

output "datalake_connector_id" {
  value = azurerm_databricks_access_connector.imdbdlconnector.id
}