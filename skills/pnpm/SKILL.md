---
name: pnpm
description: Manage Node.js packages with pnpm. Use when tasks mention pnpm commands, installing Node.js dependencies, content-addressable store, workspace monorepos, or strict package isolation.
---

# pnpm

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup, Node version management | `references/install-and-setup.md` | pnpm needs to be installed or Node.js version managed |
| .npmrc settings, workspace config, overrides | `references/configuration.md` | Project configuration or hoisting behavior needs adjustment |
| CLI commands, add/remove/run/publish | `references/command-cookbook.md` | Specific pnpm commands or workflows are needed |
| Monorepo workspaces, filters, catalog protocol | `references/workspaces.md` | Monorepo structure or cross-package commands are involved |

## Quick Start

```bash
# 1. Enable pnpm via corepack (recommended)
corepack enable
corepack prepare pnpm@latest --activate

# 2. Install all dependencies from lockfile
pnpm install

# 3. Add a package
pnpm add <pkg>

# 4. Run a script defined in package.json
pnpm run <script>
```

## Content-Addressable Store

pnpm stores all package files in a single global content-addressable store (default: `~/.pnpm-store`). When a package is installed, pnpm hard-links files from the store into `node_modules` rather than copying them. This means:

- Each unique file version is stored once on disk regardless of how many projects use it.
- Installs are faster after the first download because files already in the store are linked instantly.
- `node_modules` is strictly isolated — packages can only access their declared dependencies, preventing phantom dependency bugs.

## Core Command Tracks

- **Install all deps:** `pnpm install` — reads `pnpm-lock.yaml`; use `--frozen-lockfile` in CI
- **Add dependency:** `pnpm add <pkg>` / `pnpm add -D <pkg>` for devDependencies
- **Remove dependency:** `pnpm remove <pkg>`
- **Run script:** `pnpm run <script>` or shorthand `pnpm <script>`
- **Execute binary:** `pnpm dlx <pkg> [args]` — run without installing (like npx)
- **Update packages:** `pnpm update` / `pnpm update --latest`
- **Audit deps:** `pnpm audit --audit-level=high`
- **Recursive (monorepo):** `pnpm -r <command>` — runs across all workspace packages

## Safety Guardrails

- Always use `--frozen-lockfile` in CI to ensure the lockfile is not updated silently.
- Run `pnpm audit` regularly and address high/critical vulnerabilities.
- Avoid `shamefully-hoist=true` in `.npmrc` unless migrating a legacy project; it defeats isolation.
- Run `pnpm store prune` periodically to remove orphaned files from the global store.
- Commit `pnpm-lock.yaml` to version control; never `.gitignore` it.

```bash
# Troubleshoot phantom dependency errors: check store integrity and prune orphans
pnpm store status
pnpm store prune
pnpm install --frozen-lockfile
```

## Related Skills

- **npm** — the default Node.js package manager; pnpm is a drop-in alternative
- **yarn** — another alternative package manager with workspaces support
- **ci-architecture** — integrating pnpm into CI/CD pipelines with caching

## References

- `references/install-and-setup.md`
- `references/configuration.md`
- `references/command-cookbook.md`
- `references/workspaces.md`
- Official docs: <https://pnpm.io/motivation>
- CLI reference: <https://pnpm.io/cli/add>
- Workspace docs: <https://pnpm.io/workspaces>
- Filtering: <https://pnpm.io/filtering>
