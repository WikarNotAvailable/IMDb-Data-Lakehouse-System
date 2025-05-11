variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Azure resource group"
}

variable "service_principal_id" {
  type = string
  description = "Service principal ID of imdb app"
}