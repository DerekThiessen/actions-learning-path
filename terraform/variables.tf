# Required variables
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "environment" {
  description = "Target environment (dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

# App Service variables
variable "deploy_app_service" {
  description = "Deploy Azure App Service"
  type        = bool
  default     = false
}

variable "app_service_name" {
  description = "Name for the App Service"
  type        = string
  default     = ""
  validation {
    condition = var.deploy_app_service == false || (var.deploy_app_service == true && length(var.app_service_name) > 0)
    error_message = "app_service_name is required when deploy_app_service is true."
  }
}

variable "app_service_plan_sku" {
  description = "App Service Plan SKU"
  type        = string
  default     = "F1"
  validation {
    condition     = contains(["F1", "B1", "B2", "B3", "S1", "S2", "S3", "P1", "P2", "P3"], var.app_service_plan_sku)
    error_message = "Invalid App Service Plan SKU. Must be one of: F1, B1, B2, B3, S1, S2, S3, P1, P2, P3."
  }
}

# Key Vault variables
variable "deploy_key_vault" {
  description = "Deploy Azure Key Vault"
  type        = bool
  default     = false
}

variable "key_vault_name" {
  description = "Name for the Key Vault"
  type        = string
  default     = ""
  validation {
    condition = var.deploy_key_vault == false || (var.deploy_key_vault == true && length(var.key_vault_name) > 0)
    error_message = "key_vault_name is required when deploy_key_vault is true."
  }
}

# Storage Account variables
variable "deploy_storage_account" {
  description = "Deploy Azure Storage Account"
  type        = bool
  default     = false
}

variable "storage_account_name" {
  description = "Name for the Storage Account"
  type        = string
  default     = ""
  validation {
    condition = var.deploy_storage_account == false || (var.deploy_storage_account == true && length(var.storage_account_name) > 0)
    error_message = "storage_account_name is required when deploy_storage_account is true."
  }
}

variable "storage_account_type" {
  description = "Storage Account type"
  type        = string
  default     = "Standard_LRS"
  validation {
    condition     = contains(["Standard_LRS", "Standard_GRS", "Standard_ZRS", "Premium_LRS"], var.storage_account_type)
    error_message = "Invalid storage account type. Must be one of: Standard_LRS, Standard_GRS, Standard_ZRS, Premium_LRS."
  }
}

# SQL Database variables
variable "deploy_sql_database" {
  description = "Deploy Azure SQL Database"
  type        = bool
  default     = false
}

variable "sql_server_name" {
  description = "Name for the SQL Server"
  type        = string
  default     = ""
  validation {
    condition = var.deploy_sql_database == false || (var.deploy_sql_database == true && length(var.sql_server_name) > 0)
    error_message = "sql_server_name is required when deploy_sql_database is true."
  }
}

variable "sql_database_name" {
  description = "Name for the SQL Database"
  type        = string
  default     = ""
  validation {
    condition = var.deploy_sql_database == false || (var.deploy_sql_database == true && length(var.sql_database_name) > 0)
    error_message = "sql_database_name is required when deploy_sql_database is true."
  }
}

variable "sql_admin_login" {
  description = "SQL Server administrator login"
  type        = string
  default     = "azureuser"
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  default     = ""
  sensitive   = true
  validation {
    condition = var.deploy_sql_database == false || (var.deploy_sql_database == true && length(var.sql_admin_password) >= 8)
    error_message = "sql_admin_password must be at least 8 characters long when deploy_sql_database is true."
  }
}