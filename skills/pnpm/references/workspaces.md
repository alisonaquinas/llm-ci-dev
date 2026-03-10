# pnpm — Workspaces

## pnpm-workspace.yaml Format

Define which directories are workspace packages. Place this file at the repository root.

```yaml
packages:
  - "packages/*"       # all direct children of packages/
  - "apps/*"           # all direct children of apps/
  - "!**/__tests__/**" # exclude test directories
```

After any change to `pnpm-workspace.yaml`, run `pnpm install` to rebuild the workspace links.

## Recursive Commands

Run a command across all workspace packages:

```bash
# Build every package
pnpm -r run build

# Test every package
pnpm -r run test

# Run in parallel (faster, but interleaved output)
pnpm -r --parallel run build
```

## Filters (--filter)

Target a subset of workspace packages:

```bash
# A specific package by name (as in package.json "name" field)
pnpm --filter @myorg/utils run build

# A package and everything that depends on it
pnpm --filter @myorg/utils... run build

# A package and all its dependencies
pnpm --filter ...@myorg/utils run build

# Packages changed since a git ref
pnpm --filter "...[origin/main]" run test

# Packages matching a glob on their directory path
pnpm --filter "./packages/ui-*" run lint
```

## workspace: Protocol

Reference workspace packages directly by name instead of using relative paths:

```json
{
  "dependencies": {
    "@myorg/utils": "workspace:*",
    "@myorg/ui": "workspace:^1.0.0"
  }
}
```

- `workspace:*` — always links to the local version, regardless of its version field.
- `workspace:^` / `workspace:~` — links locally but publishes with a resolved semver range.

## Catalog Protocol

The catalog protocol (pnpm 9+) centralizes version declarations to keep versions consistent across all workspace packages:

Define versions once in `pnpm-workspace.yaml`:

```yaml
packages:
  - "packages/*"

catalog:
  react: "^18.3.0"
  typescript: "^5.4.0"
  vitest: "^1.6.0"
```

Reference in any `package.json`:

```json
{
  "dependencies": {
    "react": "catalog:"
  },
  "devDependencies": {
    "typescript": "catalog:",
    "vitest": "catalog:"
  }
}
```

Updating a version in the catalog propagates to all packages automatically on the next `pnpm install`.

## Shared devDependencies Pattern

Install shared tooling at the root to avoid repetition:

```bash
# Install at root only
pnpm add -D -w typescript eslint prettier
```

The `-w` flag (or `--workspace-root`) targets the root `package.json`.
