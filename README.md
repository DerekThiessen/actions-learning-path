## Essentials of GitHub Actions learning pathway demo repository

This repository contains the core web application files and configuration you'll need to follow along through the [Essentials of automated application deployment with GitHub Actions & GitHub Pages](https://resources.github.com/learn/pathways/automation/essentials/automated-application-deployment-with-github-actions-and-pages/) module.

To follow along with the step-by-step instructions in the Essentials module, you will need to create a copy of this repository by doing the following:
1. Click **Use this template** above the file list and select **Create a new repository**.
2. Use the **Owner** dropdown menu to select the account you want to own the repository. 
3. Name your repository `actions-learning-pathway` and add a simple description to make it easier to identify later.
4. Set the default visibility for the repo to public, as private repositories use Actions minutes, while public repositories can use GitHub-hosted runners for free.

Click Create repository from template and we’re ready to build our first Actions workflow!
## Azure Resources Deployment Template

This repository now also includes a comprehensive reusable workflow template for deploying Azure resources using Terraform in an "à la carte" fashion. Development teams can select exactly which Azure resources they want to deploy:

- **Azure App Service** with Service Plan
- **Azure Key Vault** for secrets management
- **Azure Storage Account** for blob storage
- **Azure SQL Database** with SQL Server

### Key Features
- 🎯 **Modular Resource Selection**: Choose only the resources you need
- 🌍 **Multi-Environment Support**: Deploy to dev, staging, and production
- 🔒 **Security Best Practices**: Secure authentication and secret management
- ⚙️ **Terraform Integration**: Uses existing IaC modules for consistent deployments
- 🚀 **GitHub Actions Native**: Seamless integration with GitHub workflows

### Quick Start

1. **Configure Azure Authentication**: Set up service principal credentials in GitHub Secrets
2. **Customize Terraform**: Modify the terraform files for your specific needs
3. **Deploy Resources**: Use the reusable workflow template in your deployment pipelines

See the [Azure Template Documentation](./docs/AZURE_TEMPLATE_README.md) for detailed setup and usage instructions.

### Example Usage

```yaml
jobs:
  deploy-azure:
    uses: ./.github/workflows/azure-resources-template.yml
    with:
      resource_group_name: "my-app-rg-dev"
      environment: "dev"
      deploy_app_service: true
      app_service_name: "my-app-dev"
      deploy_key_vault: true
      key_vault_name: "my-app-kv-dev"
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
```

---



If you have arrived here from the [Intermediate automation strategies with GitHub Actions](https://resources.github.com/learn/pathways/automation/intermediate/workflow-automation-with-github-actions/) module without following the first module, copy the contents of the `/demo-files` folder into the `.github/workflows` folder to follow along.
