variable "resource_group" {
  type        = object({
    name = string
    location = string
  })
  description = "Azure resource group"
}