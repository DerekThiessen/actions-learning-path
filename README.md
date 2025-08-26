## Essentials of GitHub Actions learning pathway demo repository

This repository contains the core web application files and configuration you'll need to follow along through the [Essentials of automated application deployment with GitHub Actions & GitHub Pages](https://resources.github.com/learn/pathways/automation/essentials/automated-application-deployment-with-github-actions-and-pages/) module.

To follow along with the step-by-step instructions in the Essentials module, you will need to create a copy of this repository by doing the following:
1. Click **Use this template** above the file list and select **Create a new repository**.
2. Use the **Owner** dropdown menu to select the account you want to own the repository. 
3. Name your repository `actions-learning-pathway` and add a simple description to make it easier to identify later.
4. Set the default visibility for the repo to public, as private repositories use Actions minutes, while public repositories can use GitHub-hosted runners for free.

Click Create repository from template and we’re ready to build our first Actions workflow!



If you have arrived here from the [Intermediate automation strategies with GitHub Actions](https://resources.github.com/learn/pathways/automation/intermediate/workflow-automation-with-github-actions/) module without following the first module, copy the contents of the `/demo-files` folder into the `.github/workflows` folder to follow along.

## .NET Build Template

This repository now includes a reusable workflow template for building .NET applications! The template provides:

- ✨ **Reusable workflow** for .NET builds across multiple projects
- 🚀 **Configurable settings** for .NET version, build configuration, and more  
- 🧪 **Automated testing** with code coverage collection
- 📦 **Artifact publishing** for distributing your applications
- 🔄 **Caching support** for faster builds
- 🌐 **Cross-platform** support (Linux, Windows, macOS)

### Quick Start

1. Check out the **`dotnet-example/`** directory for a complete working example
2. Use the **`.github/workflows/dotnet-build-template.yml`** in your own projects
3. See **`dotnet-example/README.md`** for detailed usage instructions

### Example Usage

```yaml
jobs:
  build:
    uses: ./.github/workflows/dotnet-build-template.yml
    with:
      dotnet-version: '8.x'
      project-path: './src'
      publish-artifacts: true
```
