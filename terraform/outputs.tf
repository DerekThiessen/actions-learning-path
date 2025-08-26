# Resource Group outputs
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.main.id
}

# App Service outputs
output "app_service_url" {
  description = "URL of the App Service"
  value       = var.deploy_app_service ? "https://${azurerm_linux_web_app.main[0].default_hostname}" : null
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = var.deploy_app_service ? azurerm_linux_web_app.main[0].name : null
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = var.deploy_app_service ? azurerm_service_plan.main[0].name : null
}

# Key Vault outputs
output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = var.deploy_key_vault ? azurerm_key_vault.main[0].vault_uri : null
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = var.deploy_key_vault ? azurerm_key_vault.main[0].name : null
}

# Storage Account outputs
output "storage_account_name" {
  description = "Name of the Storage Account"
  value       = var.deploy_storage_account ? azurerm_storage_account.main[0].name : null
}

output "storage_account_primary_endpoint" {
  description = "Primary endpoint of the Storage Account"
  value       = var.deploy_storage_account ? azurerm_storage_account.main[0].primary_blob_endpoint : null
}

output "storage_account_connection_string" {
  description = "Connection string for the Storage Account"
  value       = var.deploy_storage_account ? azurerm_storage_account.main[0].primary_connection_string : null
  sensitive   = true
}

# SQL Database outputs
output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = var.deploy_sql_database ? azurerm_mssql_server.main[0].name : null
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = var.deploy_sql_database ? azurerm_mssql_server.main[0].fully_qualified_domain_name : null
}

output "sql_database_name" {
  description = "Name of the SQL Database"
  value       = var.deploy_sql_database ? azurerm_mssql_database.main[0].name : null
}

output "sql_connection_string" {
  description = "Connection string for the SQL Database"
  value = var.deploy_sql_database ? "Server=tcp:${azurerm_mssql_server.main[0].fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main[0].name};Persist Security Info=False;User ID=${var.sql_admin_login};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" : null
  sensitive = true
}

# Summary output
output "deployed_resources" {
  description = "Summary of deployed resources"
  value = {
    resource_group    = azurerm_resource_group.main.name
    app_service      = var.deploy_app_service ? azurerm_linux_web_app.main[0].name : "Not deployed"
    key_vault        = var.deploy_key_vault ? azurerm_key_vault.main[0].name : "Not deployed"
    storage_account  = var.deploy_storage_account ? azurerm_storage_account.main[0].name : "Not deployed"
    sql_database     = var.deploy_sql_database ? "${azurerm_mssql_server.main[0].name}/${azurerm_mssql_database.main[0].name}" : "Not deployed"
  }
}