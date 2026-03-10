# pnpm — Install and Setup

## Recommended: Install via Corepack

Corepack is bundled with Node.js 16.9+ and manages package manager versions per project.

```bash
# Enable corepack (run once per machine)
corepack enable

# Activate a specific pnpm version
corepack prepare pnpm@latest --activate

# Pin the version in package.json (adds "packageManager" field)
corepack use pnpm@latest
```

When `"packageManager": "pnpm@x.y.z"` is set in `package.json`, corepack automatically uses that version in the project.

## Install via npm

```bash
npm install -g pnpm
```

Upgrade with the same command or with:

```bash
pnpm add -g pnpm
```

## Install via Standalone Script

```bash
# Unix/macOS
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Windows PowerShell
iwr https://get.pnpm.io/install.ps1 -useb | iex
```

## Node.js Version Management with pnpm env

pnpm includes a built-in Node.js version manager:

```bash
# List available Node.js versions
pnpm env list --remote

# Install and use a specific Node.js version
pnpm env use --global 20

# Install and use the latest LTS
pnpm env use --global lts
```

This removes the need for separate tools like nvm or fnm in many workflows.

## .npmrc Settings for pnpm

Place `.npmrc` in the project root or home directory to configure pnpm behavior:

```ini
# Use a shared store location (useful for CI caching)
store-dir=~/.pnpm-store

# Prevent phantom dependencies (default in pnpm, explicit here for clarity)
shamefully-hoist=false

# Hoist only specific packages (e.g., for tooling that needs global access)
public-hoist-pattern[]=*eslint*
public-hoist-pattern[]=*prettier*

# Fail on peer dependency conflicts
strict-peer-dependencies=true
```

## Verify Installation

```bash
pnpm --version
pnpm store path
```
