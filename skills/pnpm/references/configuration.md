# pnpm — Configuration

## .npmrc Key Settings

pnpm reads `.npmrc` from the project root, user home, and global locations. Project-level settings take precedence.

```ini
# ── Store ──────────────────────────────────────────────────────────────────
# Override the global content-addressable store location
store-dir=~/.pnpm-store

# ── Hoisting ───────────────────────────────────────────────────────────────
# Hoist all packages to the root node_modules (NOT recommended; breaks isolation)
shamefully-hoist=false

# Hoist only specific packages by glob (preferred over shamefully-hoist)
public-hoist-pattern[]=*eslint*
public-hoist-pattern[]=*prettier*
public-hoist-pattern[]=@types/*

# ── Peer Dependencies ──────────────────────────────────────────────────────
# Warn on missing peer deps (default: true in pnpm 8+)
strict-peer-dependencies=true

# ── Registry ───────────────────────────────────────────────────────────────
registry=https://registry.npmjs.org/

# Scoped registry example
@myorg:registry=https://npm.pkg.github.com
```

## pnpm-workspace.yaml

Defines the packages included in a monorepo workspace. Must be at the repository root.

```yaml
packages:
  # All packages directly under packages/
  - "packages/*"
  # All apps directly under apps/
  - "apps/*"
  # A specific package
  - "tools/build-utils"
  # Exclude a specific directory
  - "!**/test/**"
```

## overrides Field in package.json

Force a specific version of a transitive dependency across the entire dependency tree:

```json
{
  "pnpm": {
    "overrides": {
      "lodash": "^4.17.21",
      "semver@<7.5.2": "^7.5.2"
    }
  }
}
```

Use overrides to patch known vulnerabilities in transitive deps without waiting for upstream updates.

## packageExtensions Field

Extend the manifest of third-party packages when they have missing or incorrect peer dependencies:

```json
{
  "pnpm": {
    "packageExtensions": {
      "react-redux@1": {
        "peerDependencies": {
          "react-dom": "*"
        }
      }
    }
  }
}
```

## neverBuiltDependencies

Prevent specific packages from running lifecycle scripts during install:

```json
{
  "pnpm": {
    "neverBuiltDependencies": ["fsevents", "esbuild"]
  }
}
```
