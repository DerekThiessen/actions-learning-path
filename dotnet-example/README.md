# .NET Build Template

This directory contains a reusable GitHub Actions workflow template for building .NET applications, along with an example project demonstrating its usage.

## Files

- **`.github/workflows/dotnet-build-template.yml`** - The reusable workflow template
- **`.github/workflows/dotnet-example.yml`** - Example workflow showing how to use the template
- **`dotnet-example/`** - Sample .NET console application with tests

## Reusable Template Features

The `.NET Build Template` provides a flexible, reusable workflow for building .NET applications with the following features:

### Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `dotnet-version` | .NET version to use | No | `6.x` |
| `project-path` | Path to the .NET project or solution file | No | `.` |
| `build-configuration` | Build configuration (Debug/Release) | No | `Release` |
| `run-tests` | Whether to run tests | No | `true` |
| `publish-artifacts` | Whether to publish build artifacts | No | `false` |
| `artifact-name` | Name for the published artifact | No | `dotnet-app` |
| `runs-on` | Runner to use | No | `ubuntu-latest` |

### Outputs

| Output | Description |
|--------|-------------|
| `build-status` | Status of the build job |
| `test-status` | Status of the test job |

### Jobs

1. **Build** - Restores dependencies, builds the application, and optionally publishes artifacts
2. **Test** - Runs unit tests with code coverage collection (only if `run-tests` is true)

### Features

- **Caching**: Automatically caches NuGet packages for faster builds
- **Code Coverage**: Collects code coverage data during test runs
- **Artifact Publishing**: Optionally publishes build artifacts
- **Multi-Runner Support**: Can run on different runners (ubuntu-latest, windows-latest, etc.)
- **Flexible Configuration**: Supports different .NET versions and build configurations

## Usage Examples

### Basic Usage

```yaml
name: Build My .NET App

on: [push, pull_request]

jobs:
  build:
    uses: ./.github/workflows/dotnet-build-template.yml
    with:
      project-path: './src'
```

### Advanced Usage with Custom Settings

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build:
    uses: ./.github/workflows/dotnet-build-template.yml
    with:
      dotnet-version: '8.x'
      project-path: './MyApp.sln'
      build-configuration: 'Release'
      run-tests: true
      publish-artifacts: true
      artifact-name: 'my-application'
      runs-on: 'ubuntu-latest'
```

### Matrix Build for Multiple .NET Versions

```yaml
name: Multi-Version Build

on: [push, pull_request]

jobs:
  build:
    strategy:
      matrix:
        dotnet-version: ['6.x', '7.x', '8.x']
    uses: ./.github/workflows/dotnet-build-template.yml
    with:
      dotnet-version: ${{ matrix.dotnet-version }}
      project-path: './src'
      artifact-name: 'app-${{ matrix.dotnet-version }}'
```

### Cross-Platform Build

```yaml
name: Cross-Platform Build

on: [push, pull_request]

jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    uses: ./.github/workflows/dotnet-build-template.yml
    with:
      runs-on: ${{ matrix.os }}
      project-path: './src'
      artifact-name: 'app-${{ matrix.os }}'
```

## Example Project

The `dotnet-example/` directory contains a sample .NET console application that demonstrates:

- A simple console application with a Calculator class
- Comprehensive unit tests using xUnit
- Proper project structure with solution file
- All features working with the reusable template

You can explore this example to understand how to structure your .NET projects for use with the template.

## Getting Started

1. Copy the `dotnet-build-template.yml` file to your repository's `.github/workflows/` directory
2. Create a workflow file that references the template (see examples above)
3. Customize the inputs based on your project's needs
4. Commit and push to trigger the workflow

## Best Practices

1. **Use specific .NET versions** in production workflows for consistency
2. **Enable artifact publishing** for release builds
3. **Use matrix builds** to test against multiple .NET versions
4. **Cache dependencies** for faster builds (automatically handled by the template)
5. **Organize projects** in solutions for complex applications
6. **Include comprehensive tests** to take advantage of the testing features

## Troubleshooting

- Ensure your project path is correct relative to the repository root
- Verify that your .NET version is supported by the GitHub runners
- Check that test projects have proper references to the main application
- For private NuGet feeds, you may need to configure authentication in your workflow