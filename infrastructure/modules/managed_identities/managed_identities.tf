resource "azurerm_databricks_access_connector" "imdbmetastoreconnector" {
  name                = "imdb-metastore-connector"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_databricks_access_connector" "imdbdlconnector" {
  name                = "imdb-datalake-connector"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  identity {
    type = "SystemAssigned"
  }
}