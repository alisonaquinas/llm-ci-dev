---
name: rvm
description: Manage Ruby versions and gemsets with rvm. Use when tasks mention rvm, Ruby version management, gemsets, or .ruby-version with rvm.
---

# rvm

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| GPG key import, curl installer, shell integration | `references/install-and-setup.md` | rvm needs to be installed or the shell integration is missing |
| install/use/list/gemset/current/uninstall commands | `references/command-cookbook.md` | Specific rvm commands are needed |
| Creating, using, and deleting gemsets | `references/gemsets.md` | Gemset isolation or the @global gemset is the topic |
| .ruby-version, .rvmrc, autoswitch on cd | `references/project-files.md` | Project-level Ruby or gemset pinning is the topic |

## Quick Start

```bash
# Install Ruby 3.3
rvm install 3.3

# Switch to it
rvm use 3.3

# Make it the default
rvm use 3.3 --default

# List installed rubies
rvm list
```

## Core Command Tracks

- **Install Ruby:** `rvm install 3.3` / `rvm install ruby-3.3.0`
- **Switch version:** `rvm use 3.3`
- **Set default:** `rvm use 3.3 --default`
- **List rubies:** `rvm list` / `rvm list known`
- **Gemsets:** `rvm gemset create myapp`, `rvm gemset use myapp`
- **Current ruby:** `rvm current`
- **Remove ruby:** `rvm uninstall 3.1`

## Safety Guardrails

- Import the GPG key before installing rvm to verify the installer signature.
- Always run rvm as a login shell function — do not invoke it as a plain command in non-login sub-shells.
- Commit `.ruby-version` (not `.rvmrc`) to version control; `.rvmrc` requires `rvm rvmrc trust` per machine.
- Use project-specific gemsets to isolate gem dependencies and avoid version conflicts between projects.

## Workflow

1. Install the target Ruby version with `rvm install <version>`.
2. Create a project gemset: `rvm gemset create <name>`.
3. Switch to version + gemset: `rvm use <version>@<name>`.
4. Write `.ruby-version` and `.ruby-gemset` (or use `rvm --create --ruby-version use`) to autoswitch.
5. Run `bundle install` to install project gems into the active gemset.

```bash
# Troubleshoot: rvm not found in a sub-shell, source the shell function manually
source "$HOME/.rvm/scripts/rvm"
rvm current
rvm list
```

## Related Skills

- **rbenv** — alternative Ruby version manager (lighter weight, no gemsets)
- **asdf** — universal version manager that also handles Ruby

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/gemsets.md`
- `references/project-files.md`
- Official site: <https://rvm.io>
- Troubleshooting: <https://rvm.io/support/troubleshooting>
