# Setup & Installation

Get the YAML Language Server running in Docker.

## Prerequisites

- Docker installed and running
- An LSP-aware editor (Neovim, VS Code, Zed, Helix, etc.)

## Pulling the Image

The yaml-language-server runs on `node:lts-alpine`, a lightweight Node.js container:

```bash
# Pull the Node LTS Alpine image
docker pull node:lts-alpine
```

The image is small (~150 MB) and widely maintained by the Node.js project.

## Verifying Installation

Check that Node and npx are available:

```bash
# Verify Node is installed
docker run --rm node:lts-alpine node --version

# Verify npx is available
docker run --rm node:lts-alpine npx --version
```

## Starting the Server

### First Run

On first execution, npx will download the yaml-language-server package (~15 MB).
This one-time setup may take 10–15 seconds.

```bash
# Start in stdio mode (interactive)
docker run --rm -i -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --stdio
```

Subsequent runs are fast as the package is cached in the container.

## Configuring Schemas (Optional)

The YAML Language Server automatically validates against known schemas
(Kubernetes, GitHub Workflows, etc.) if it recognizes the file.

For custom schemas, add `yaml.schemas` configuration in your editor settings.

## Persistent Cache (Advanced)

To avoid re-downloading on each run, use a named Docker volume:

```bash
# Create volume for npm cache
docker volume create yaml-lsp-cache

# Use volume
docker run --rm -i -v "$(pwd):/workspace" -v yaml-lsp-cache:/root/.npm \
  node:lts-alpine npx --yes yaml-language-server --stdio
```

## Next Steps

- Integrate the server startup command in your editor configuration (see Editor Configuration guide)
- Run the server in stdio mode for editor integration
- Optionally configure JSON schemas for custom YAML validation
