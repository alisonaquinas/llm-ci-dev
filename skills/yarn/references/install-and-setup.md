# Yarn Install & Setup

## Recommended: Corepack (Berry / v2+)

Corepack is bundled with Node.js 16.9+ and is the preferred way to install and manage Yarn Berry:

```bash
# Enable corepack (once per machine)
corepack enable

# Activate the latest stable Yarn
corepack prepare yarn@stable --activate

# Verify
yarn --version
```

Corepack reads the `packageManager` field in `package.json` and automatically uses the declared version when inside that project directory.

## Legacy: Global Install (Classic v1)

For projects still on Yarn Classic:

```bash
npm install -g yarn

# Verify
yarn --version  # should print 1.x.x
```

## Selecting a Yarn Version with Corepack

```bash
# Pin a specific Berry version for a project
corepack prepare yarn@4.1.0 --activate

# Or let Yarn manage itself via yarn set version
yarn set version stable
yarn set version 4.1.0
yarn set version classic   # downgrade to v1 in a project
```

This updates the `packageManager` field in `package.json` and places the Yarn binary in `.yarn/releases/`.

## packageManager Field

Declaring the package manager in `package.json` ensures every contributor and CI runner uses the same version:

```json
{
  "packageManager": "yarn@4.1.0"
}
```

With corepack enabled, running `yarn` in that directory automatically downloads and uses `4.1.0`.

## Platform Notes

### macOS

```bash
# Via Homebrew (installs Classic v1)
brew install yarn

# Recommended: use corepack instead
corepack enable
```

### Windows

```powershell
# Via winget (Classic v1)
winget install Yarn.Yarn

# Recommended: use corepack after installing Node.js
corepack enable
```

### Linux

Install Node.js first (see the npm install-and-setup reference), then:

```bash
corepack enable
corepack prepare yarn@stable --activate
```

## Zero-Install Setup

Berry supports committing the Yarn cache to the repository so `yarn install` is not required in CI:

```bash
# .gitattributes additions for zero-install
echo '/.yarn/cache/** linguist-vendored' >> .gitattributes
```

Check `.yarn/cache/` into version control and set `enableGlobalCache: false` in `.yarnrc.yml`.
