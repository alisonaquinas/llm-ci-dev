---
name: asdf
description: Manage multiple language runtime versions with asdf. Use when tasks mention asdf, .tool-versions, or managing multiple language runtimes with a single tool.
---

# asdf

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| git clone install, Homebrew, shell integration, plugin overview | `references/install-and-setup.md` | asdf needs to be installed or the shell integration is missing |
| plugin add/install/global/local/current/list/reshim commands | `references/command-cookbook.md` | Specific asdf commands are needed |
| Finding plugins, popular plugins, plugin lifecycle | `references/plugins-and-tools.md` | Adding or managing plugins for a new language/tool is the topic |
| .tool-versions format, inheritance, CI usage | `references/tool-versions.md` | Project-level version pinning or CI configuration is the topic |

## Quick Start

```bash
# Add the Node.js plugin and install a version
asdf plugin add nodejs
asdf install nodejs 20.14.0
asdf global nodejs 20.14.0

# Pin versions for a project (writes .tool-versions)
asdf local nodejs 20.14.0
asdf local python 3.12.3

# Check active versions
asdf current
```

## Core Command Tracks

- **Add plugin:** `asdf plugin add <name>`
- **Install version:** `asdf install <name> <version>`
- **Global default:** `asdf global <name> <version>`
- **Project pin:** `asdf local <name> <version>` (writes `.tool-versions`)
- **Active versions:** `asdf current`
- **List installed:** `asdf list <name>`
- **Reshim binaries:** `asdf reshim <name>`

```bash
# Troubleshoot missing binary after npm global install
npm install -g typescript
asdf reshim nodejs
which tsc   # should now resolve to the asdf shim
```

## Safety Guardrails

- Run `asdf reshim <name>` after installing packages that provide new CLI binaries (e.g. after `npm install -g`).
- Commit `.tool-versions` to version control so all contributors and CI use the same runtime versions.
- Keep plugins up to date with `asdf plugin update --all` periodically.
- Prefer `asdf local` over editing `.tool-versions` by hand to avoid formatting errors.

## Workflow

1. Add the required plugin: `asdf plugin add <name>`.
2. Install the version: `asdf install <name> <version>`.
3. Set global default: `asdf global <name> <version>`.
4. In a project directory, pin with `asdf local <name> <version>`.
5. Verify with `asdf current` and commit `.tool-versions`.

## Related Skills

- **nvm** — dedicated Node.js version manager
- **pyenv** — dedicated Python version manager
- **rbenv** — dedicated Ruby version manager
- **direnv** — per-directory environment variables, integrates with asdf

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/plugins-and-tools.md`
- `references/tool-versions.md`
- Getting started: <https://asdf-vm.com/guide/getting-started.html>
- Full command reference: <https://asdf-vm.com/manage/commands.html>
- Troubleshooting: <https://asdf-vm.com/troubleshoot/>
