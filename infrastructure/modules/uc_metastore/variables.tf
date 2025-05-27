variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Azure resource group"
}

variable "metastore_connector_principal_id" {
  type        = string
  description = "Access connector principal id of metastore connector"
}

variable "databricks_workspace_id" {
  type        = string
  description = "Databricks workspace id"
}