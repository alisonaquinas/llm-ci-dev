---
name: nvm
description: Manage multiple Node.js versions with nvm. Use when tasks mention nvm, Node.js version switching, .nvmrc, or managing multiple Node versions per project.
---

# nvm

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install nvm, shell profile integration, verify install | `references/install-and-setup.md` | nvm needs to be installed or the shell integration is not working |
| Install/use/alias/list/uninstall Node versions | `references/command-cookbook.md` | Specific nvm commands are needed |
| .nvmrc project file, default alias, auto-use on cd | `references/nvmrc-and-defaults.md` | Project-level Node version pinning is the topic |
| Lazy loading, fish shell, Windows alternatives | `references/shell-integration.md` | Shell startup performance or non-bash shells are the topic |

## Quick Start

```bash
# Install Node.js LTS
nvm install --lts

# Use a specific version
nvm use 20

# Pin version for a project
echo "20" > .nvmrc
nvm use   # reads .nvmrc automatically

# List installed versions
nvm ls
```

## Core Command Tracks

- **Install a version:** `nvm install 20` / `nvm install --lts`
- **Switch version:** `nvm use 20` / `nvm use --lts`
- **Set default:** `nvm alias default 20`
- **List installed:** `nvm ls`
- **List available:** `nvm ls-remote`
- **Run with version:** `nvm exec 18 node app.js`
- **Remove a version:** `nvm uninstall 16`

## Safety Guardrails

- Always commit `.nvmrc` to version control so all team members use the same Node version.
- Set `nvm alias default <version>` after installing to ensure new shells use the correct version.
- Never rely on the system node when nvm is active — use `nvm alias system` only for explicit fallback.
- In CI, install the version specified in `.nvmrc` with `nvm install` rather than hardcoding a version in the pipeline.

## Workflow

1. Install the desired Node.js version with `nvm install <version>`.
2. Activate it with `nvm use <version>`.
3. Set it as default with `nvm alias default <version>` to persist across new shells.
4. Pin the project version by writing `<version>` to `.nvmrc` and committing it.
5. In CI, run `nvm install` (reads `.nvmrc`) followed by `nvm use`.

## Related Skills

- **npm** — Node.js package manager used alongside nvm
- **yarn** — alternative package manager for Node.js projects
- **pnpm** — disk-efficient Node.js package manager
- **asdf** — universal version manager that also handles Node.js

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/nvmrc-and-defaults.md`
- `references/shell-integration.md`
- Official repo: <https://github.com/nvm-sh/nvm>
- Troubleshooting (macOS): <https://github.com/nvm-sh/nvm#troubleshooting-on-macos>
- Troubleshooting (Linux): <https://github.com/nvm-sh/nvm#troubleshooting-on-linux>
