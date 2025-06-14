resource "azurerm_data_factory" "adf" {
  name                = "imdb-adf"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_factory_pipeline" "imdbpipeline" {
  name            = "imdb-pipeline"
  data_factory_id = azurerm_data_factory.adf.id
  activities_json = jsonencode(local.imdb_pipeline_activities) 
}

resource "azurerm_data_factory_pipeline" "imdbsilver" {
  name            = "imdb-silver"
  data_factory_id = azurerm_data_factory.adf.id
  activities_json = jsonencode(local.silver_pipeline_activities) 
}

resource "azurerm_data_factory_pipeline" "imdbgold" {
  name            = "imdb-gold"
  data_factory_id = azurerm_data_factory.adf.id
  activities_json = jsonencode(local.gold_pipeline_activities) 
}

resource "azurerm_data_factory_linked_service_azure_databricks" "imdblinkedservice" {
  name                       = "ADBLinkedServiceViaMSI"
  data_factory_id            = azurerm_data_factory.adf.id
  description                = "ADB Linked Service via MSI"
  adb_domain                 = var.databricks_workspace_url
  existing_cluster_id        = var.databricks_cluster_id
  msi_work_space_resource_id = var.databricks_workspace_resource_id
}

resource "azurerm_role_assignment" "dlcontributor" {
  scope                = var.databricks_workspace_resource_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.adf.identity[0].principal_id
}
