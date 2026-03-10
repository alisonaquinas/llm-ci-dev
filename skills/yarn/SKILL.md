---
name: yarn
description: Manage JavaScript packages with Yarn. Use when tasks mention yarn commands, .yarnrc.yml configuration, Yarn Berry, Yarn Classic, Plug'n'Play, or JavaScript package operations using the yarn binary.
---

# Yarn

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install Yarn, first-time setup, version selection | `references/install-and-setup.md` | Yarn needs to be installed or a specific version activated |
| .yarnrc.yml, nodeLinker, plugins, PnP | `references/configuration.md` | Yarn configuration files or settings are the topic |
| CLI commands, workflows | `references/command-cookbook.md` | Specific yarn commands are needed |
| Monorepo workspaces, constraints, foreach | `references/workspaces.md` | Workspace or monorepo setup is the topic |

## Quick Start

```bash
# 1. Activate Yarn via Corepack (recommended for Berry)
corepack enable && corepack prepare yarn@stable --activate

# 2. Install all dependencies
yarn

# 3. Add a package
yarn add <pkg>

# 4. Run a script defined in package.json
yarn run <script>
```

## Classic (v1) vs Berry (v3 / v4)

Yarn has two major release lines:

| Aspect | Classic (v1) | Berry (v2+) |
| --- | --- | --- |
| Config file | `.yarnrc` | `.yarnrc.yml` |
| Default linker | node_modules | PnP (Plug'n'Play) |
| Install | `yarn install` | `yarn install` |
| Version pin | `yarn` global | `packageManager` in package.json |
| Recommended for new projects | No | Yes |

Switch a project to Berry:

```bash
corepack prepare yarn@4 --activate
yarn set version stable
```

## Core Command Tracks

- **Install all deps:** `yarn install` / `yarn` (shorthand)
- **Add package:** `yarn add <pkg>`, `yarn add --dev <pkg>`
- **Remove package:** `yarn remove <pkg>`
- **Run script:** `yarn run <script>`, `yarn <script>` (shorthand in Berry)
- **Upgrade packages:** `yarn up <pkg>`
- **Audit:** `yarn npm audit`
- **Execute binary:** `yarn dlx <cmd>` (like npx)

## Safety Guardrails

- Use `--immutable` in CI to prevent the lock file from being updated during install.
- Run `yarn npm audit` to check for known vulnerabilities before releasing.
- Plug'n'Play (PnP) mode is stricter than node_modules — phantom dependencies will cause runtime errors; this is intentional and helps surface real issues.
- When migrating from Classic to Berry, test PnP compatibility for all dependencies; fall back to `nodeLinker: node-modules` in `.yarnrc.yml` if needed.
- Commit `.yarn/releases/` and `.pnp.cjs` (if using PnP) to version control.

## Workflow

1. Activate the correct Yarn version via corepack or check the `packageManager` field.
2. Run `yarn install` to install dependencies.
3. Add or upgrade packages with `yarn add` / `yarn up`.
4. Run scripts with `yarn run <script>`.
5. In CI, run `yarn install --immutable`.
6. Publish with `yarn npm publish`.

## Related Skills

- **npm** — Node.js built-in package manager; lock file is `package-lock.json`
- **pnpm** — disk-efficient package manager with a content-addressable store
- **ci-architecture** — integrating Yarn into CI/CD pipelines

## References

- `references/install-and-setup.md`
- `references/configuration.md`
- `references/command-cookbook.md`
- `references/workspaces.md`
- Official docs (Berry): <https://yarnpkg.com/getting-started>
- Migration guide (Classic → Berry): <https://yarnpkg.com/migration/guide>
- Configuration reference: <https://yarnpkg.com/configuration/yarnrc>
- CLI reference: <https://yarnpkg.com/cli>
