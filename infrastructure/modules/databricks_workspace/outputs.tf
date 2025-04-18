output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.dbworkspace.workspace_url}/"
}