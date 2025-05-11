terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.74.0"
    }
  }
}

resource "databricks_secret_scope" "kv" {
  name                     = "imdb-scope"
  initial_manage_principal = "users"
  keyvault_metadata {
    resource_id = var.resource_id
    dns_name    = var.dns_name
  }
}

resource "databricks_cluster_policy" "all_purpose_clusters" {
  name       = "IMDb cluster policy"
  definition = jsonencode(local.default_policy)
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "dev_cluster" {
  cluster_name            = "Development cluster"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = "Standard_F4"
  policy_id               = databricks_cluster_policy.all_purpose_clusters.id
  data_security_mode      = "SINGLE_USER"
  single_user_name        = "wikar8998@gmail.com"
  autotermination_minutes = 10
  custom_tags = {
    "ResourceClass" = "SingleNode"
  }
  spark_conf = {
    "spark.databricks.cluster.photon.enabled" = "false"
    "spark.databricks.cluster.profile"        = "singleNode"
    "spark.master"                            = "local[*, 4]"
  }
}