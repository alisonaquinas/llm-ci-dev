# nvm Command Cookbook

## Install Node.js Versions

```bash
# Install the latest LTS release
nvm install --lts

# Install a specific major version (picks latest patch)
nvm install 20

# Install an exact version
nvm install 20.14.0

# Install and immediately use
nvm install 18 --default
```

## Switch Versions

```bash
# Switch to an installed version
nvm use 20

# Switch to LTS
nvm use --lts

# Switch to the system-installed Node (outside nvm)
nvm use system
```

## Aliases

```bash
# Set the default version for new shells
nvm alias default 20

# Create a named alias
nvm alias myproject 18.20.3

# Use a named alias
nvm use myproject

# Remove an alias
nvm unalias myproject

# List all aliases
nvm alias
```

## List Versions

```bash
# List installed versions (with alias annotations)
nvm ls

# List all available remote versions
nvm ls-remote

# Filter remote list to LTS versions only
nvm ls-remote --lts

# Filter by major version
nvm ls-remote 20
```

## Run Commands with a Specific Version

```bash
# Run a command with a specific version without switching globally
nvm exec 18 node --version
nvm exec 18 npm install
```

## Uninstall

```bash
# Remove an installed version
nvm uninstall 16

# Remove an LTS version
nvm uninstall --lts/fermium
```

## Useful One-Liners

```bash
# Print the path to the current node binary
nvm which current

# Print the path to a specific version's binary
nvm which 20

# Run a script using the version specified in .nvmrc
nvm run node app.js
```
