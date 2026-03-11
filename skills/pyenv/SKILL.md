---
name: pyenv
description: Manage multiple Python versions with pyenv. Use when tasks mention pyenv, Python version switching, .python-version, or pyenv-virtualenv.
---

# pyenv

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| pyenv-installer, Homebrew, build dependencies, shell integration | `references/install-and-setup.md` | pyenv needs to be installed or the shell integration is missing |
| install/global/local/shell/versions/which commands | `references/command-cookbook.md` | Specific pyenv commands are needed |
| pyenv-virtualenv plugin, virtualenv creation, auto-activation | `references/virtualenvs.md` | Virtual environment management with pyenv is the topic |
| .python-version, shell > local > global, PYENV_VERSION | `references/project-files.md` | Project-level Python version pinning or precedence is the topic |

## Quick Start

```bash
# Install Python 3.12.3
pyenv install 3.12.3

# Set as global default
pyenv global 3.12.3

# Pin version for a project (writes .python-version)
pyenv local 3.12.3

# Confirm active version
pyenv version
```

## Core Command Tracks

- **Install Python:** `pyenv install 3.12.3`
- **Global default:** `pyenv global 3.12.3`
- **Project pin:** `pyenv local 3.12.3` (writes `.python-version`)
- **Shell override:** `pyenv shell 3.11.9` (current shell only)
- **List installed:** `pyenv versions`
- **List available:** `pyenv install --list`
- **Resolve binary:** `pyenv which python`

## Safety Guardrails

- Install OS build dependencies before running `pyenv install` to avoid compilation failures.
- Commit `.python-version` to version control so all contributors use the same Python.
- Use `pyenv-virtualenv` for project-level virtual environments rather than system venv directly.
- Set `PYENV_VERSION` in CI only if `.python-version` is not present in the repository.

## Workflow

1. Install build dependencies for the OS (see `references/install-and-setup.md`).
2. Install the target Python: `pyenv install <version>`.
3. Set global default: `pyenv global <version>`.
4. For a project, `cd` into the directory and run `pyenv local <version>`.
5. Create a virtualenv: `pyenv virtualenv <version> <name>` and activate it.

## Related Skills

- **pip** — Python package installer used within pyenv-managed environments
- **poetry** — dependency and virtualenv manager that works with pyenv
- **pipenv** — Pipfile-based environment manager that integrates with pyenv
- **asdf** — universal version manager that also handles Python

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/virtualenvs.md`
- `references/project-files.md`
- Official repo: <https://github.com/pyenv/pyenv>
- Common build problems: <https://github.com/pyenv/pyenv/wiki/Common-build-problems>
- Full command reference: <https://github.com/pyenv/pyenv/blob/master/COMMANDS.md>
