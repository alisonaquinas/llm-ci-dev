---
name: rbenv
description: Manage Ruby versions with rbenv. Use when tasks mention rbenv, Ruby version switching, .ruby-version, or ruby-build.
---

# rbenv

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Homebrew install, rbenv-installer, shell integration | `references/install-and-setup.md` | rbenv needs to be installed or shell integration is missing |
| install/global/local/shell/versions/rehash commands | `references/command-cookbook.md` | Specific rbenv commands are needed |
| ruby-build plugin, build from source, RUBY_CONFIGURE_OPTS | `references/ruby-build.md` | Building or listing installable Ruby versions is the topic |
| .ruby-version, shell > local > global precedence | `references/project-files.md` | Project-level Ruby version pinning or precedence is the topic |

## Quick Start

```bash
# Install Ruby 3.3.0
rbenv install 3.3.0

# Set as global default
rbenv global 3.3.0

# Pin version for a project (writes .ruby-version)
rbenv local 3.3.0

# Verify active version
rbenv version
```

## Core Command Tracks

- **Install Ruby:** `rbenv install 3.3.0`
- **Global default:** `rbenv global 3.3.0`
- **Project pin:** `rbenv local 3.3.0` (writes `.ruby-version`)
- **Shell override:** `rbenv shell 3.2.0` (current shell only)
- **List installed:** `rbenv versions`
- **List available:** `rbenv install --list`
- **Rehash shims:** `rbenv rehash` (run after installing gems with executables)

## Safety Guardrails

- Run `rbenv rehash` after installing any gem that provides a CLI binary (e.g. `bundler`, `rails`).
- Commit `.ruby-version` to version control so all contributors use the same Ruby.
- Do not modify the `PATH` manually before `rbenv init` runs — let the shell integration manage shims.
- Prefer `rbenv local` over setting `RBENV_VERSION` manually to keep the version declaration in the repo.

## Workflow

1. Install the target Ruby: `rbenv install <version>`.
2. Set global default: `rbenv global <version>`.
3. For a project, `cd` into the directory and run `rbenv local <version>`.
4. Confirm with `rbenv version` and `ruby -v`.
5. After `bundle install`, run `rbenv rehash` to register new binstubs.

```bash
# Troubleshoot: gem binary not found after install, refresh shims
gem install bundler
rbenv rehash
rbenv which bundler
```

## Related Skills

- **rvm** — alternative Ruby version manager with built-in gemset support
- **asdf** — universal version manager that also handles Ruby

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/ruby-build.md`
- `references/project-files.md`
- Official repo: <https://github.com/rbenv/rbenv>
- Shell hook details: <https://github.com/rbenv/rbenv#how-rbenv-hooks-into-your-shell>
- ruby-build docs: <https://github.com/rbenv/ruby-build#readme>
