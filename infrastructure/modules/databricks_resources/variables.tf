variable "dns_name" {
  type        = string
  description = "Secret scope dns name"
}

variable "resource_id" {
  type        = string
  description = "Secret scope resource id"
}

variable "location" {
  type        = string
  description = "Location for resources"
}

variable "datalake_connector_id" {
  type        = string
  description = "Access connector id of datalake connector"
}

locals {
  default_policy = {
    "spark_conf.spark.databricks.cluster.profile" : {
      "type" : "fixed",
      "value" : "singleNode",
      "hidden" : true
    },
    "spark_conf.spark.databricks.cluster.photon.enabled" : {
      "type" : "fixed",
      "value" : "false"
    },
    "node_type_id" : {
      "type" : "allowlist",
      "values" : [
        "Standard_D4s_v3",
        "Standard_D8s_v3",
        "Standard_D8_v3",
        "Standard_E8_v3",
        "Standard_E8s_v3",
        "Standard_F4",
        "Standard_F4s",
        "Standard_F8",
        "Standard_F8s"
      ],
      "defaultValue" : "Standard_F4"
    },
    "autotermination_minutes" : {
      "type" : "unlimited",
      "defaultValue" : 10
    },
    "spark_version" : {
      "type" : "fixed",
      "value" : "auto:latest-lts"
    },
    "cluster_type" : {
      "type" : "fixed",
      "value" : "all-purpose"
    }
  }
}