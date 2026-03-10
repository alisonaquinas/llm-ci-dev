---
name: yaml-lsp
description: >
  Run the YAML Language Server in a Docker container.
  Provide real-time YAML validation, completion, and hover information without local installation.
---

# YAML Language Server

Enable YAML language server capabilities (completion, validation, diagnostics) using
the Red Hat YAML Language Server in Docker.

This skill provides a containerized Language Server Protocol (LSP) implementation for YAML files,
compatible with Neovim, VS Code, Helix, Zed, and other LSP-aware editors.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Setup & Installation | `references/install-and-setup.md` | Getting Docker and the LSP running |
| Quick Reference | `references/quick-reference.md` | Need startup flags and LSP capabilities |
| Editor Configuration | `references/editor-configuration.md` | Integrating with editor (Neovim, VS Code, etc.) |
| Troubleshooting | `references/troubleshooting.md` | Debugging LSP startup or connection issues |

---

## Quick Start

### Startup Modes

The YAML Language Server can run in two modes:

1. **Stdio mode** — Suitable for editors that launch LSP as a subprocess
2. **Socket mode** — Suitable for remote connections or multi-editor setups

### Stdio Mode (Recommended for Most Editors)

```bash
docker run --rm -i -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --stdio
```

Editor communicates with the server over stdin/stdout.

### Socket Mode

```bash
docker run --rm -p 7998:7998 -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --socket=7998
```

Editor connects to the server on TCP port 7998.

### Common Editor Integration

**Neovim (nvim-lspconfig):**

```lua
require('lspconfig').yamlls.setup({
  cmd = {
    'docker', 'run', '--rm', '-i', '-v', vim.fn.getcwd() .. ':/workspace',
    'node:lts-alpine', 'npx', '--yes', 'yaml-language-server', '--stdio'
  }
})
```

---

## LSP Capabilities

The YAML Language Server provides:

- **Diagnostics** — Real-time syntax and schema validation
- **Completion** — IntelliSense for keys and values
- **Hover Information** — Type hints and documentation
- **Formatting** — Auto-format YAML files
- **Schema Association** — Link YAML files to JSON schemas for validation

---

## Configuration

Associate YAML files with JSON schemas in editor settings:

```json
{
  "yaml.schemas": {
    "https://json.schemastore.org/github-workflow.json": ".github/workflows/*.yml",
    "https://json.schemastore.org/kube-config.json": "kubeconfig"
  }
}
```

---

## Related References

- Load **Quick Reference** for startup flags and protocol modes
- Load **Editor Configuration** to integrate with your editor
- Load **Troubleshooting** if the server fails to start or connect
