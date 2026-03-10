# Troubleshooting

Resolve common YAML Language Server issues.

## Container Not Found

**Error:** `Unable to find image 'node:lts-alpine:latest'`

**Solution:** Pull the image:

```bash
docker pull node:lts-alpine
```

## Server Won't Start

**Error:** `Error: Cannot find module 'yaml-language-server'`

**Cause:** npx failed to download the package (network issue, corrupted cache)

**Solution:** Clear npm cache and retry:

```bash
# Remove npm cache volume
docker volume rm yaml-lsp-cache 2>/dev/null || true

# Retry server startup
docker run --rm -i -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --stdio
```

## Slow First Run

**Problem:** Server takes 10–15 seconds to start on first execution

**Cause:** npx is downloading yaml-language-server (~15 MB)

**Solution:** This is normal. Subsequent runs are fast. To avoid re-downloading,
use a Docker volume to persist the npm cache (see Install & Setup guide).

## Workspace Root Mismatch

**Error:** `No schemas found` or schemas not loading

**Cause:** Server's workspace root doesn't match actual project root

**Solution:** Ensure the working directory is correct in your editor config:

```bash
# Verify editor passes correct working directory
# In Neovim: print(vim.fn.getcwd())
# In VS Code: terminal shows project path

# In editor config, confirm:
# - Volume mount path is correct: -v $(pwd):/workspace
# - YAML.workspaceRoot matches: /workspace
```

## Connection Refused (Socket Mode)

**Error:** `connection refused` on port 7998

**Cause:** Container not running or port not exposed

**Solution:** Verify port mapping:

```bash
# Check if container is running
docker ps

# Ensure -p flag is set
docker run --rm -p 7998:7998 -v "$(pwd):/workspace" \
  node:lts-alpine npx --yes yaml-language-server --socket=7998

# Check port is available (no other service using it)
lsof -i :7998
```

## Schema Not Loading

**Error:** `Errors validating schema` or schema errors don't appear

**Cause:** Schema URL is unreachable or mismatched file pattern

**Solution:** Verify schema configuration:

```json
{
  "yaml.schemas": {
    "https://json.schemastore.org/github-workflow.json": ".github/workflows/*.yml"
  }
}
```

- Ensure URL is reachable: `curl https://json.schemastore.org/github-workflow.json`
- Check file path pattern matches your YAML files
- Try built-in schema recognition (no config needed for common files)

## Permission Denied

**Error:** `Permission denied` on workspace directory

**Cause:** Volume mount permissions or Docker daemon access

**Solution:** Check file permissions:

```bash
# Ensure current directory is readable
chmod +r *.yml

# Or run Docker with appropriate context
# On Mac/Linux, ensure Docker daemon has access
```

## Formatting Not Working

**Problem:** Format command doesn't indent or change anything

**Cause:** Formatting disabled in server or editor config

**Solution:** Enable formatting:

```json
{
  "yaml": {
    "format": {
      "enable": true,
      "singleQuote": true,
      "bracketSpacing": true
    }
  }
}
```

## Diagnostics Not Showing

**Problem:** No validation errors appear in editor

**Cause:** Diagnostics disabled, schema not associated, or server not running

**Solution:**

1. Check server is running (look for `--stdio` or `--socket` in process list)
2. Verify schema association in editor config (see Editor Configuration)
3. Check editor LSP output panel for warnings
4. Restart server and editor

## Memory Issues

**Problem:** Container exits unexpectedly or uses excessive memory

**Cause:** Large YAML files or aggressive schema validation

**Solution:** Set memory limits or increase container resources:

```bash
# Limit container memory
docker run --rm -i --memory=512m \
  -v "$(pwd):/workspace" node:lts-alpine \
  npx --yes yaml-language-server --stdio
```
