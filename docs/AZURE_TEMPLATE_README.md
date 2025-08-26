# Azure Resources Deployment Template

This repository provides a reusable GitHub Actions workflow template for deploying Azure resources using Terraform in an "à la carte" fashion, allowing development teams to select exactly which Azure resources they want to deploy.

## Features

- **Modular Resource Selection**: Choose which resources to deploy:
  - Azure App Service with Service Plan
  - Azure Key Vault
  - Azure Storage Account
  - Azure SQL Database with SQL Server
- **Multi-Environment Support**: Deploy to dev, staging, and production environments
- **Terraform Integration**: Uses existing IaC modules for consistent deployments
- **Security Best Practices**: Secure secret management and environment protection
- **Flexible Configuration**: Customizable resource names, SKUs, and settings

## Quick Start

1. **Set up Azure Service Principal**: Create an Azure AD app registration for authentication
2. **Configure Repository Secrets**: Add required secrets to your GitHub repository
3. **Create Terraform Configuration**: Set up your Terraform files in the `terraform/` directory
4. **Use the Template**: Reference the reusable workflow in your deployment workflows

## Repository Secrets

Configure the following secrets in your GitHub repository:

### Required Secrets
- `AZURE_CLIENT_ID`: Azure Service Principal Client ID
- `AZURE_CLIENT_SECRET`: Azure Service Principal Client Secret
- `AZURE_SUBSCRIPTION_ID`: Your Azure Subscription ID
- `AZURE_TENANT_ID`: Your Azure AD Tenant ID

### Optional Secrets
- `SQL_ADMIN_PASSWORD`: Password for SQL Server administrator (required if deploying SQL Database)

## Usage

### Basic Usage

Create a workflow file (e.g., `.github/workflows/deploy-azure.yml`):

```yaml
name: Deploy Azure Resources

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        default: 'dev'
        type: choice
        options: ['dev', 'staging', 'prod']

jobs:
  deploy:
    uses: ./.github/workflows/azure-resources-template.yml
    with:
      resource_group_name: "my-app-rg-${{ github.event.inputs.environment }}"
      environment: "${{ github.event.inputs.environment }}"
      location: "East US"
      deploy_app_service: true
      app_service_name: "my-app-${{ github.event.inputs.environment }}"
      deploy_key_vault: true
      key_vault_name: "my-app-kv-${{ github.event.inputs.environment }}"
      deploy_storage_account: true
      storage_account_name: "myappst${{ github.event.inputs.environment }}"
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
```

### Advanced Usage with All Resources

```yaml
jobs:
  deploy:
    uses: ./.github/workflows/azure-resources-template.yml
    with:
      resource_group_name: "full-stack-rg-prod"
      environment: "prod"
      location: "East US"
      # App Service Configuration
      deploy_app_service: true
      app_service_name: "full-stack-app-prod"
      app_service_plan_sku: "P1"
      # Key Vault Configuration
      deploy_key_vault: true
      key_vault_name: "full-stack-kv-prod"
      # Storage Account Configuration
      deploy_storage_account: true
      storage_account_name: "fullstackstprod"
      storage_account_type: "Standard_GRS"
      # SQL Database Configuration
      deploy_sql_database: true
      sql_server_name: "full-stack-sql-prod"
      sql_database_name: "fullstackdb"
      sql_admin_login: "dbadmin"
      # Terraform Configuration
      terraform_version: "1.5.7"
      working_directory: "./infrastructure/terraform"
      auto_approve: false
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      SQL_ADMIN_PASSWORD: ${{ secrets.SQL_ADMIN_PASSWORD }}
```

## Template Parameters

### Required Parameters
- `resource_group_name`: Name of the Azure Resource Group
- `environment`: Target environment (dev, staging, prod)
- `location`: Azure region for resources

### Resource Selection Parameters
- `deploy_app_service`: Whether to deploy Azure App Service (boolean)
- `deploy_key_vault`: Whether to deploy Azure Key Vault (boolean)
- `deploy_storage_account`: Whether to deploy Azure Storage Account (boolean)
- `deploy_sql_database`: Whether to deploy Azure SQL Database (boolean)

### App Service Parameters
- `app_service_name`: Name for the App Service (required if deploying)
- `app_service_plan_sku`: Service Plan SKU (F1, B1, B2, B3, S1, S2, S3, P1, P2, P3)

### Key Vault Parameters
- `key_vault_name`: Name for the Key Vault (required if deploying)

### Storage Account Parameters
- `storage_account_name`: Name for the Storage Account (required if deploying)
- `storage_account_type`: Storage Account type (Standard_LRS, Standard_GRS, Standard_ZRS, Premium_LRS)

### SQL Database Parameters
- `sql_server_name`: Name for the SQL Server (required if deploying)
- `sql_database_name`: Name for the SQL Database (required if deploying)
- `sql_admin_login`: SQL Server administrator username (default: azureuser)

### Terraform Parameters
- `terraform_version`: Terraform version to use (default: 1.5.7)
- `working_directory`: Directory containing Terraform files (default: ./terraform)
- `auto_approve`: Auto-approve Terraform apply (use with caution, default: false)

## Terraform Structure

The template expects your Terraform configuration in the specified working directory with:

- `main.tf`: Resource definitions
- `variables.tf`: Variable declarations
- `outputs.tf`: Output definitions

### Example Terraform Variables

Your `variables.tf` should include:

```hcl
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "environment" {
  description = "Target environment"
  type        = string
}

variable "deploy_app_service" {
  description = "Deploy Azure App Service"
  type        = bool
  default     = false
}

# ... other variables for each resource type
```

## Azure Resources Created

Depending on your selections, the template can create:

### App Service
- Azure App Service Plan (Linux)
- Azure App Service (Linux Web App with Node.js 18-LTS)

### Key Vault
- Azure Key Vault with standard SKU
- Access policy for the service principal
- Soft-delete enabled (7-day retention)

### Storage Account
- Azure Storage Account with specified replication type
- Configurable performance tier

### SQL Database
- Azure SQL Server with specified admin credentials
- Azure SQL Database (S0 SKU by default)
- Firewall rule to allow Azure services

## Security Considerations

1. **Service Principal**: Use a dedicated service principal with minimal required permissions
2. **Secrets Management**: Store all sensitive values as GitHub repository secrets
3. **Environment Protection**: Configure environment protection rules in GitHub
4. **Terraform State**: Configure remote state storage in Azure for production workloads
5. **Manual Approval**: Keep `auto_approve: false` for production deployments

## Setting up Azure Service Principal

1. Create a service principal:
```bash
az ad sp create-for-rbac --name "github-actions-sp" --role="Contributor" --scopes="/subscriptions/{subscription-id}"
```

2. The output will contain the values for your GitHub secrets:
```json
{
  "clientId": "your-client-id",
  "clientSecret": "your-client-secret", 
  "subscriptionId": "your-subscription-id",
  "tenantId": "your-tenant-id"
}
```

3. Add these values as secrets in your GitHub repository settings.

## Environment Setup

For production deployments, set up GitHub environments with protection rules:

1. Go to Settings → Environments
2. Create environments: `dev`, `staging`, `prod`
3. Configure protection rules for production (required reviewers, deployment branches)
4. Add environment-specific secrets if needed

## Troubleshooting

### Common Issues

1. **Authentication Errors**: Verify Azure credentials are correctly set in GitHub secrets
2. **Resource Name Conflicts**: Ensure resource names are unique across Azure
3. **Permission Errors**: Check service principal has sufficient permissions
4. **Terraform State Lock**: Remove state locks if deployment was interrupted

### Validation Steps

The template includes input validation that checks:
- Required resource names are provided when resources are enabled
- Terraform files exist in the specified directory
- Azure authentication is successful before deployment

## Contributing

To extend this template:

1. Add new resource types in `terraform/main.tf`
2. Add corresponding variables in `variables.tf` and `outputs.tf`
3. Update the workflow template with new input parameters
4. Update this documentation

## Examples

See the example workflow in `.github/workflows/azure-resources-example.yml` for a complete implementation that demonstrates:

- Environment-specific deployments
- Resource selection via workflow dispatch inputs
- Different SKUs and configurations per environment
- Proper secret management