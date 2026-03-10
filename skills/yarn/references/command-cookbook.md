# Yarn Command Cookbook

## Install Dependencies

```bash
# Install all dependencies (reads yarn.lock)
yarn install
yarn          # shorthand

# CI-safe install — fails if yarn.lock would be modified
yarn install --immutable
```

## Add & Remove Packages

```bash
# Add a runtime dependency
yarn add express

# Add a dev dependency
yarn add --dev typescript

# Add a peer dependency
yarn add --peer react

# Add an exact version
yarn add lodash@4.17.21

# Remove a package
yarn remove lodash
```

## Run Scripts

```bash
# Run any script defined in package.json
yarn run build
yarn run test

# Berry shorthand (omit "run")
yarn build
yarn test
```

## Upgrade Packages

```bash
# Upgrade a package to the latest compatible version
yarn up lodash

# Upgrade to the latest (ignoring semver range)
yarn up lodash@latest

# Interactive upgrade (requires interactive-tools plugin)
yarn upgrade-interactive
```

## Audit

```bash
# Check for known vulnerabilities
yarn npm audit

# Audit with JSON output
yarn npm audit --json
```

## Execute Binaries (dlx)

`yarn dlx` runs a package binary without permanently installing it (similar to npx):

```bash
# Run create-react-app once
yarn dlx create-react-app my-app

# Run a specific version
yarn dlx --package typescript@5 tsc --version
```

## Publish

```bash
# Pack the package into a tarball (no publish)
yarn pack

# Publish to the npm registry
yarn npm publish

# Publish a pre-release
yarn npm publish --tag beta
```

## Inspect

```bash
# Why is a package installed?
yarn why lodash

# List all packages in the dependency tree
yarn info --all

# Deduplicate redundant package versions
yarn dedupe
```

## Info & Version

```bash
# Show current Yarn version
yarn --version

# Show resolved versions of a package
yarn info react versions

# Bump package version (Berry)
yarn version patch
yarn version minor
yarn version major
```

## Useful Flags Summary

| Flag | Command | Effect |
| --- | --- | --- |
| `--immutable` | `install` | Fails if lock file needs updating (use in CI) |
| `--dev` | `add` | Saves to devDependencies |
| `--peer` | `add` | Saves to peerDependencies |
| `--json` | most | Machine-readable output |
| `--workspace <name>` | most | Targets a specific workspace |
