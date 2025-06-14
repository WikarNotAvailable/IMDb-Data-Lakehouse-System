variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Azure resource group"
}

variable "databricks_workspace_url" {
  type        = string
  description = "IMDb databricks workspace url"
}

variable "databricks_workspace_resource_id" {
  type        = string
  description = "IMDb databricks workspace resource id"
}

variable "databricks_cluster_id" {
  type        = string
  description = "Databricks cluster id"
}

locals {
  imdb_pipeline_activities = [
    {
      "name" : "Clear tables",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create locations and schema",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/2.clear_tables"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Create bronze tables",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Clear tables",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/3.create_bronze_tables"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Create locations and schema",
      "type" : "DatabricksNotebook",
      "state" : "Inactive",
      "onInactiveMarkAs" : "Succeeded",
      "dependsOn" : [
        {
          "activity" : "Extract and load",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/1.create_locations_and_schemas"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Extract and load",
      "type" : "DatabricksNotebook",
      "state" : "Inactive",
      "onInactiveMarkAs" : "Succeeded",
      "dependsOn" : [],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/extract_load"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Execute silver pipeline",
      "type" : "ExecutePipeline",
      "dependsOn" : [
        {
          "activity" : "Create bronze tables",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "pipeline" : {
          "referenceName" : "imdb-silver",
          "type" : "PipelineReference"
        },
        "waitOnCompletion" : true
      }
    },
    {
      "name" : "Execute gold pipeline",
      "type" : "ExecutePipeline",
      "dependsOn" : [
        {
          "activity" : "Execute silver pipeline",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "pipeline" : {
          "referenceName" : "imdb-gold",
          "type" : "PipelineReference"
        },
        "waitOnCompletion" : true
      }
    }
  ]
  silver_pipeline_activities = [
    {
      "name" : "Create silver tables",
      "type" : "DatabricksNotebook",
      "dependsOn" : [],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/4.create_silver_tables"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Transform name basics",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create silver tables",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/6.transform_name_basics"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Transform title principals",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create silver tables",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/7.transform_title_principals"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Transform title episodes",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create silver tables",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/8.transform_title_episode"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Transform title basics",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create silver tables",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/9.transform_title_basics"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Transform title ratings",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create silver tables",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/10.transform_title_ratings"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Transform title AKAS",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create silver tables",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/11.transform_title_akas"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    }
  ]
  gold_pipeline_activities = [
    {
      "name" : "Create gold layer",
      "type" : "DatabricksNotebook",
      "dependsOn" : [],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/5.create_gold_tables"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Model title dim",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create gold layer",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/13.model_title"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Model participation fact",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create gold layer",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/14.model_participation"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Rename existing dimensions",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create gold layer",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/12.rename_existing_dims"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    },
    {
      "name" : "Model AKAS dim",
      "type" : "DatabricksNotebook",
      "dependsOn" : [
        {
          "activity" : "Create gold layer",
          "dependencyConditions" : [
            "Succeeded"
          ]
        }
      ],
      "policy" : {
        "timeout" : "0.12:00:00",
        "retry" : 0,
        "retryIntervalInSeconds" : 30,
        "secureOutput" : false,
        "secureInput" : false
      },
      "userProperties" : [],
      "typeProperties" : {
        "notebookPath" : "/Shared/15.model_akas"
      },
      "linkedServiceName" : {
        "referenceName" : "ADBLinkedServiceViaMSI",
        "type" : "LinkedServiceReference"
      }
    }
  ]
}
