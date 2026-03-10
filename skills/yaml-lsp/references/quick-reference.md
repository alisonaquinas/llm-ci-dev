# Quick Reference

YAML Language Server startup flags and capabilities.

## Startup Flags

| Flag | Purpose |
| --- | --- |
| `--stdio` | Communicate via stdin/stdout (editor subprocess mode) |
| `--socket=<port>` | Listen on TCP port (remote connection mode) |
| `--help` | Display help and exit |

## Common Startup Commands

```bash
# Stdio mode (editor subprocess)
docker run --rm -i -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --stdio

# Socket mode on port 7998
docker run --rm -p 7998:7998 -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --socket=7998

# Socket mode with custom port
docker run --rm -p 3000:3000 -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --socket=3000
```

## LSP Capabilities

The server provides standard LSP features:

| Capability | Example |
| --- | --- |
| **Diagnostics** | Real-time syntax validation, schema errors |
| **Completion** | Press Ctrl+Space for key/value suggestions |
| **Hover** | Hover over keys to see documentation |
| **Formatting** | Auto-format with editor format command |
| **Go to Definition** | Jump to schema definitions (if available) |
| **Signature Help** | Context-aware hints while typing |

## Schema Association

Schemas tell the server what to validate against. Specify in editor configuration:

```json
{
  "yaml.schemas": {
    "https://json.schemastore.org/github-workflow.json": ".github/workflows/*.yml",
    "https://json.schemastore.org/kube-config.json": "kubeconfig",
    "https://json.schemastore.org/docker-compose.json": "docker-compose.yml"
  }
}
```

## Built-in Schema Recognition

The server recognizes common file patterns automatically:

- `docker-compose.yml` → Docker Compose schema
- `.github/workflows/*.yml` → GitHub Actions workflow schema
- `kubeconfig` → Kubernetes config schema
- `Chart.yaml` → Helm chart schema

No additional configuration needed for these.

## Common Settings

Pass `initializationOptions` to configure the server:

```json
{
  "yaml.customTags": [
    "!base64",
    "!vault"
  ],
  "yaml.format": {
    "enable": true,
    "singleQuote": true,
    "bracketSpacing": true
  }
}
```

## Debugging Output

Enable verbose output to diagnose issues:

```bash
# Check server startup (look for error messages)
docker run --rm -i -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --stdio 2>&1 | head -20
```

Check the editor's LSP logs (usually in LSP output panel).
