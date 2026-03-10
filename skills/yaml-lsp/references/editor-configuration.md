# Editor Configuration

Wire the YAML Language Server into your editor.

## Neovim (nvim-lspconfig)

Add to your Neovim config (Lua):

```lua
local lspconfig = require('lspconfig')

lspconfig.yamlls.setup({
  cmd = {
    'docker', 'run', '--rm', '-i',
    '-v', vim.fn.getcwd() .. ':/workspace',
    'node:lts-alpine',
    'npx', '--yes', 'yaml-language-server', '--stdio'
  },
  settings = {
    yaml = {
      schemas = {
        ['https://json.schemastore.org/github-workflow.json'] = '.github/workflows/*.yml',
        ['https://json.schemastore.org/kube-config.json'] = 'kubeconfig'
      },
      format = { enable = true }
    }
  }
})
```

## VS Code

### Option 1: Remote Container Extension

Use VS Code's Remote Containers extension to run your editor context in Docker,
then install the YAML extension normally.

### Option 2: Custom LSP Configuration

In `.vscode/settings.json`:

```json
{
  "yaml.trace.server": "verbose",
  "[yaml]": {
    "editor.defaultFormatter": "redhat.vscode-yaml"
  },
  "lspClient.customServerPath": {
    "yaml": "docker run --rm -i -v $(pwd):/workspace node:lts-alpine npx --yes yaml-language-server --stdio"
  }
}
```

## Zed

In `~/.config/zed/settings.json`:

```json
{
  "lsp": {
    "yaml": {
      "binary": {
        "path": "docker",
        "arguments": [
          "run", "--rm", "-i",
          "-v", "$ZED_WORKSPACE_ROOT:/workspace",
          "node:lts-alpine",
          "npx", "--yes", "yaml-language-server", "--stdio"
        ]
      }
    }
  }
}
```

## Helix

In `~/.config/helix/languages.toml`:

```toml
[[language]]
name = "yaml"
language-server = { command = "docker", args = [
  "run", "--rm", "-i",
  "-v", "/root:/workspace",
  "node:lts-alpine",
  "npx", "--yes", "yaml-language-server", "--stdio"
] }
```

## Other Editors

If your editor supports LSP, the general approach is:

1. **Find the LSP configuration section** (varies by editor)
2. **Set the command** to the Docker run command from Quick Reference
3. **Configure the working directory** to mount your project (usually `$(pwd)` or project root)
4. **Optionally add schema mappings** in YAML settings

### Generic Docker Command Template

```bash
docker run --rm -i \
  -v $(pwd):/workspace \
  node:lts-alpine \
  npx --yes yaml-language-server --stdio
```

Adapt paths and variables for your specific editor.

## Workspace Root

The server needs to know the project root for schema discovery.
Most editors pass this automatically. If not, specify in configuration:

```json
{
  "yaml.schemaStore": {
    "enable": true,
    "url": "https://www.schemastore.org/catalog.json"
  },
  "yaml.workspaceRoot": "/workspace"
}
```

## Custom Schemas

Map YAML files to custom schemas:

```json
{
  "yaml.schemas": {
    "file:///path/to/schema.json": "config.yml",
    "https://example.com/schema.json": "*.yaml"
  }
}
```

## Troubleshooting Configuration

- Check that the Docker command is correct (test it manually first)
- Verify the working directory/mount path matches your editor's workspace root
- Check editor LSP output for error messages
- Ensure Docker is running before opening YAML files
