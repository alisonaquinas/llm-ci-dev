# package.json Reference

## Core Identity Fields

```json
{
  "name": "my-package",
  "version": "1.2.3",
  "description": "Short human-readable description",
  "license": "MIT"
}
```

- `name`: kebab-case, scoped packages use `@scope/name`
- `version`: semver — `MAJOR.MINOR.PATCH`

## Entry Points

```json
{
  "main": "./dist/index.cjs",
  "module": "./dist/index.mjs",
  "exports": {
    ".": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.cjs"
    },
    "./utils": "./dist/utils.js"
  },
  "type": "module"
}
```

- `main`: CommonJS entry (legacy)
- `exports`: modern conditional exports map; takes priority over `main`
- `type`: `"module"` makes `.js` files ESM; omit or use `"commonjs"` for CJS

## Scripts

```json
{
  "scripts": {
    "build": "tsc",
    "test": "node --test",
    "lint": "eslint src",
    "start": "node dist/index.js",
    "prepublishOnly": "npm run build && npm test"
  }
}
```

- Lifecycle scripts (`prepare`, `prepublishOnly`, `pretest`, `postinstall`) run automatically at the right stage.
- Access locally installed binaries directly in scripts without `npx`.

## Dependency Fields

```json
{
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "typescript": "~5.4.0"
  },
  "peerDependencies": {
    "react": ">=17.0.0"
  },
  "optionalDependencies": {
    "fsevents": "^2.3.0"
  }
}
```

- `dependencies`: required at runtime
- `devDependencies`: only needed for development/build
- `peerDependencies`: the host project must supply this package
- `optionalDependencies`: install failure is non-fatal

## Version Specifiers

| Specifier | Meaning |
| --- | --- |
| `^1.2.3` | Compatible with `1.x.x` — allows minor and patch updates |
| `~1.2.3` | Approximately `1.2.x` — allows patch updates only |
| `1.2.3` | Exact version |
| `>=1.2.3 <2.0.0` | Range |
| `*` | Any version (avoid in production) |

## engines Field

```json
{
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
```

Pair with `engine-strict=true` in `.npmrc` to fail installs on incompatible runtimes.

## files Field

```json
{
  "files": ["dist", "README.md"]
}
```

Allowlist for what gets included in the published package. Complements `.npmignore`.

## packageManager Field (Corepack)

```json
{
  "packageManager": "npm@10.8.0"
}
```

When corepack is enabled, this pins the exact npm version for all contributors.
