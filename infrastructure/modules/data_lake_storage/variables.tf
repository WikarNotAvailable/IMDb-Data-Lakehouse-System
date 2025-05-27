variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Azure resource group"
}

variable "service_principal_id" {
  type        = string
  description = "Service principal ID of imdb app"
}

variable "datalake_connector_principal_id" {
  type        = string
  description = "Access connector principal id of imdb datalake connector"
}