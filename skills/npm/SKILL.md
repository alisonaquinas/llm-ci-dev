---
name: npm
description: Manage Node.js packages, run scripts, and publish with npm. Use when tasks mention npm commands, package.json configuration, dependency management, scripts, workspaces, or Node.js package operations.
---

# npm

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install Node.js, set up npm, configure .npmrc | `references/install-and-setup.md` | Node.js or npm needs to be installed or configured |
| package.json fields, version specifiers, scripts | `references/package-json.md` | package.json structure or fields are the topic |
| CLI commands, workflows | `references/command-cookbook.md` | Specific npm commands are needed |
| Monorepo workspaces, hoisting | `references/workspaces.md` | Workspace or monorepo setup is the topic |

## Quick Start

```bash
# 1. Initialize a new package
npm init -y

# 2. Install all dependencies from package.json
npm install

# 3. Run a script defined in package.json
npm run <script>

# 4. Preview what would be published (no side effects)
npm publish --dry-run
```

## Core Command Tracks

- **Initialise:** `npm init [-y]` — creates package.json
- **Install deps:** `npm install` / `npm ci` (clean, reproducible)
- **Add a package:** `npm install <pkg>`, `npm install --save-dev <pkg>`
- **Run scripts:** `npm run <script>`, `npm test`, `npm start`
- **Publish:** `npm publish [--dry-run] [--tag <tag>]`
- **Audit:** `npm audit`, `npm audit fix`
- **Update:** `npm update`, `npm outdated`
- **Execute binaries:** `npm exec <cmd>` / `npx <cmd>`

## Safety Guardrails

- Run `npm publish --dry-run` before any real publish to verify the file list.
- Run `npm audit` regularly and address high-severity advisories before releasing.
- Commit `package-lock.json` to version control; never delete it unless regenerating.
- Use `npm ci` in CI pipelines instead of `npm install` — it respects the lock file exactly and fails if it is out of sync.
- Avoid `--force` or `--legacy-peer-deps` unless the root cause of the conflict is understood.
- Keep `.npmrc` secrets (auth tokens) out of version control; use environment variables instead.

## Workflow

1. Add or update dependencies with `npm install <pkg>`.
2. Update scripts in `package.json` as needed.
3. Run `npm run <script>` to verify the change locally.
4. Run `npm audit` to check for known vulnerabilities.
5. In CI, use `npm ci` for a clean, reproducible install.
6. Publish with `npm publish --dry-run` first, then `npm publish` after confirming the output.

```bash
# Troubleshoot peer dependency conflicts and fix audit issues
npm install --legacy-peer-deps
npm audit fix
npm ls <package-name>
```

## Related Skills

- **yarn** — alternative package manager with Berry and Classic modes
- **pnpm** — disk-efficient package manager using a content-addressable store
- **ci-architecture** — integrating npm into CI/CD pipelines

## References

- `references/install-and-setup.md`
- `references/package-json.md`
- `references/command-cookbook.md`
- `references/workspaces.md`
- Official docs: <https://docs.npmjs.com>
- npm CLI reference: <https://docs.npmjs.com/cli/v10/commands>
- package.json spec: <https://docs.npmjs.com/cli/v10/configuring-npm/package-json>
- Workspaces guide: <https://docs.npmjs.com/cli/v10/using-npm/workspaces>
