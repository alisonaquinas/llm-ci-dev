# npm Command Cookbook

## Initialise

```bash
# Interactive wizard
npm init

# Accept all defaults
npm init -y
```

## Install Dependencies

```bash
# Install all deps from package.json + lock file
npm install

# Add a runtime dependency
npm install express

# Add a dev dependency
npm install --save-dev typescript

# Install exact version
npm install lodash@4.17.21

# Clean install (CI-safe: fails if lock file is out of sync)
npm ci
```

## Run Scripts

```bash
# Run any script defined in package.json
npm run build
npm run lint

# Shorthand aliases
npm test      # equivalent to npm run test
npm start     # equivalent to npm run start
```

## Publish

```bash
# Preview the publish — shows tarball contents, no upload
npm publish --dry-run

# Publish to the default registry
npm publish

# Publish with a dist-tag (e.g. beta)
npm publish --tag beta

# Pack a tarball locally without publishing
npm pack
```

## Update & Inspect

```bash
# List outdated packages
npm outdated

# Update packages within semver range
npm update

# Update a specific package
npm update lodash

# Bump version in package.json (patch/minor/major)
npm version patch
npm version minor
npm version major
```

## Audit

```bash
# Check for known vulnerabilities
npm audit

# Auto-fix compatible vulnerabilities
npm audit fix

# Fix including semver-breaking upgrades (review carefully)
npm audit fix --force
```

## Execute Binaries

```bash
# Run a locally installed binary
npm exec tsc -- --version

# Run a remote package without installing (one-time)
npx create-react-app my-app

# Equivalent using npm exec
npm exec --yes -- create-react-app my-app
```

## Link (Local Development)

```bash
# In the package being developed — register a global symlink
npm link

# In the consuming project — link to the local package
npm link my-package

# Remove the link
npm unlink my-package
```

## Useful Flags

| Flag | Applies To | Effect |
| --- | --- | --- |
| `--dry-run` | `publish`, `install` | Simulates the operation |
| `--ci` | install (via `npm ci`) | Reproducible, lock-file-strict install |
| `--save-exact` | `install` | Pins exact version instead of `^` |
| `--workspaces` / `-ws` | most commands | Runs across all workspaces |
| `--workspace=<name>` / `-w` | most commands | Runs in a specific workspace |
