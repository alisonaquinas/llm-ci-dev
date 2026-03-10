# pnpm — Command Cookbook

## Install Dependencies

```bash
# Install all dependencies (reads pnpm-lock.yaml)
pnpm install

# CI mode — fail if lockfile would be updated
pnpm install --frozen-lockfile

# Skip lifecycle scripts (faster, useful in Docker builds)
pnpm install --ignore-scripts
```

## Add Packages

```bash
# Add a runtime dependency
pnpm add express

# Add a dev dependency
pnpm add -D typescript eslint

# Add a peer dependency
pnpm add --save-peer react

# Add a specific version
pnpm add "lodash@^4.17"

# Add from a local path or git URL
pnpm add ../my-local-pkg
pnpm add github:org/repo#branch
```

## Remove Packages

```bash
pnpm remove express
pnpm remove -D typescript
```

## Run Scripts

```bash
# Run a script from package.json
pnpm run build
pnpm run test -- --watch    # pass args after --

# Shorthand (omit "run" for non-lifecycle scripts)
pnpm build
pnpm test
```

## Execute Without Installing (dlx)

```bash
# Run a package binary without installing it globally (like npx)
pnpm dlx create-react-app my-app
pnpm dlx prettier --write .
```

## Update Packages

```bash
# Update all packages within semver ranges
pnpm update

# Update to latest versions (ignores semver ranges)
pnpm update --latest

# Update a specific package
pnpm update lodash
```

## Inspect and Audit

```bash
# List installed packages
pnpm list
pnpm list --depth=0     # top-level only

# Show outdated packages
pnpm outdated

# Run security audit
pnpm audit
pnpm audit --audit-level=high    # exit non-zero only on high/critical

# Show why a package is installed
pnpm why lodash
```

## Publish

```bash
# Dry run to check what would be published
pnpm publish --dry-run

# Publish to npm registry
pnpm publish --access public
```

## Store Management

```bash
# Show store path
pnpm store path

# Remove unreferenced packages from the store
pnpm store prune

# Verify store integrity
pnpm store verify
```

## Recursive Commands (Monorepo)

```bash
# Run a command in every workspace package
pnpm -r run build
pnpm -r run test

# Run only in packages that have changed since last commit
pnpm -r --filter "...[HEAD~1]" run test
```
