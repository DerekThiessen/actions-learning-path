# Configure Terraform and Azure Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Backend configuration - update this for your storage account
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "terraformstatestorage"
  #   container_name       = "tfstate"
  #   key                 = "terraform.tfstate"
  # }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Data source to get current client configuration
data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# App Service Plan (only if App Service is enabled)
resource "azurerm_service_plan" "main" {
  count               = var.deploy_app_service ? 1 : 0
  name                = "${var.app_service_name}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  os_type            = "Linux"
  sku_name           = var.app_service_plan_sku

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# App Service (only if enabled)
resource "azurerm_linux_web_app" "main" {
  count               = var.deploy_app_service ? 1 : 0
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  service_plan_id    = azurerm_service_plan.main[0].id

  site_config {
    always_on = var.app_service_plan_sku == "F1" ? false : true
    
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "ENVIRONMENT" = var.environment
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Key Vault (only if enabled)
resource "azurerm_key_vault" "main" {
  count                       = var.deploy_key_vault ? 1 : 0
  name                        = var.key_vault_name
  resource_group_name         = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                   = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Backup", "Restore"
    ]

    storage_permissions = [
      "Get", "List", "Set", "Delete"
    ]
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Storage Account (only if enabled)
resource "azurerm_storage_account" "main" {
  count                    = var.deploy_storage_account ? 1 : 0
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  account_tier             = split("_", var.storage_account_type)[0]
  account_replication_type = split("_", var.storage_account_type)[1]

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# SQL Server (only if SQL Database is enabled)
resource "azurerm_mssql_server" "main" {
  count                        = var.deploy_sql_database ? 1 : 0
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  version                     = "12.0"
  administrator_login         = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# SQL Database (only if enabled)
resource "azurerm_mssql_database" "main" {
  count     = var.deploy_sql_database ? 1 : 0
  name      = var.sql_database_name
  server_id = azurerm_mssql_server.main[0].id
  sku_name  = "S0"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# SQL Firewall rule to allow Azure services
resource "azurerm_mssql_firewall_rule" "azure_services" {
  count            = var.deploy_sql_database ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main[0].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}