# npm Install & Setup

## Prerequisites

- A supported operating system: macOS, Linux, or Windows
- Node.js (npm is bundled with Node.js)

## Install Node.js (includes npm)

### macOS (Homebrew)

```bash
brew install node

# Verify
node -v
npm -v
```

### Linux (NodeSource binary distributions)

```bash
# Node.js 20 LTS on Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Windows

Download the installer from <https://nodejs.org/en/download/> or use winget:

```powershell
winget install OpenJS.NodeJS.LTS
```

## Version Management

### nvm (macOS / Linux)

[nvm](https://github.com/nvm-sh/nvm) allows switching between Node.js versions per project:

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install and use a specific version
nvm install 20
nvm use 20

# Pin version for a project
echo "20" > .nvmrc
nvm use   # reads .nvmrc automatically
```

### fnm (fast node manager — macOS / Linux / Windows)

```bash
# Install fnm
curl -fsSL https://fnm.vercel.app/install | bash

# Install and use Node.js 20
fnm install 20
fnm use 20
```

## Update npm

npm ships with Node.js but can be updated independently:

```bash
npm install -g npm@latest
npm -v
```

## Corepack

Corepack is included with Node.js 16.9+ and manages package manager versions:

```bash
# Enable corepack to use the packageManager field in package.json
corepack enable
```

## .npmrc Configuration

`.npmrc` files control npm behaviour at project or user level:

```ini
# .npmrc (project-level, safe to commit — no secrets)
save-exact=true
engine-strict=true
```

```bash
# Set registry (e.g. private registry)
npm config set registry https://registry.npmjs.org/

# Set auth token via environment variable (never hardcode in .npmrc)
# In CI, export NPM_TOKEN and reference it:
# //registry.npmjs.org/:_authToken=${NPM_TOKEN}
```

Common `npm config set` options:

| Key | Example value | Effect |
| --- | --- | --- |
| `save-exact` | `true` | Pins exact versions instead of `^` |
| `engine-strict` | `true` | Fails install if Node version mismatches `engines` |
| `fund` | `false` | Suppresses funding messages |
