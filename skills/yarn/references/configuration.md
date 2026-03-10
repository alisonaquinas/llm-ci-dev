# Yarn Configuration

## Berry (.yarnrc.yml)

Berry (v2+) uses `.yarnrc.yml` at the project root. All keys are documented at <https://yarnpkg.com/configuration/yarnrc>.

### Minimal example

```yaml
yarnPath: .yarn/releases/yarn-4.1.0.cjs

nodeLinker: node-modules   # or pnp (default) or pnpm
```

### nodeLinker

Controls how packages are linked into the project:

| Value | Behaviour |
| --- | --- |
| `pnp` | Plug'n'Play — no `node_modules`, uses a `.pnp.cjs` loader |
| `node-modules` | Traditional `node_modules` tree (maximum compatibility) |
| `pnpm` | pnpm-style content-addressable layout |

Switch to `node-modules` linker for packages that do not support PnP:

```yaml
nodeLinker: node-modules
```

### yarnPath

Points to the Yarn binary committed into the repository:

```yaml
yarnPath: .yarn/releases/yarn-4.1.0.cjs
```

Set automatically when running `yarn set version <version>`.

### npmAuthToken

Configure registry authentication without storing tokens in plain text:

```yaml
npmAuthToken: "${NPM_TOKEN}"
```

Reference an environment variable rather than hardcoding the value.

### Scoped registry

```yaml
npmScopes:
  my-org:
    npmRegistryServer: "https://npm.pkg.github.com"
    npmAuthToken: "${GITHUB_TOKEN}"
```

### Plugins

```yaml
plugins:
  - path: .yarn/plugins/@yarnpkg/plugin-interactive-tools.cjs
    spec: "@yarnpkg/plugin-interactive-tools"
```

Install plugins with:

```bash
yarn plugin import interactive-tools
yarn plugin import version
```

## Classic (.yarnrc)

Yarn Classic uses a simpler key-value `.yarnrc` file:

```ini
registry "https://registry.npmjs.org"
yarn-offline-mirror ".yarn/cache"
```

Most Classic configuration can also be set via environment variables prefixed with `YARN_`.

## Environment Variables

| Variable | Effect |
| --- | --- |
| `YARN_CACHE_FOLDER` | Override the global cache path |
| `YARN_ENABLE_IMMUTABLE_INSTALLS` | Set `true` to enforce `--immutable` globally |
| `YARN_NPM_AUTH_TOKEN` | Registry auth token |

## .yarnignore

Equivalent to `.npmignore` for controlling what is excluded from published packages when using `yarn pack` or `yarn npm publish`.
