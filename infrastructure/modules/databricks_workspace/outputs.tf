output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.dbworkspace.workspace_url}/"
}

output "databricks_resource_id" {
  value = azurerm_databricks_workspace.dbworkspace.id
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.dbworkspace.workspace_id
}