---
name: pip
description: Install and manage Python packages with pip. Use when tasks mention pip commands, Python packages, virtual environments, requirements.txt, or PyPI indexes.
---

# pip

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install pip, upgrade pip, pip.conf settings | `references/install-and-setup.md` | pip needs to be installed, upgraded, or configured globally |
| requirements.txt, version specifiers, indexes, hashes | `references/requirements-and-indexes.md` | Dependency files, private indexes, or hash pinning is involved |
| CLI commands, install/freeze/list/wheel | `references/command-cookbook.md` | Specific pip commands or package workflows are needed |
| venv creation, activation, site-packages, pipx | `references/virtual-environments.md` | Virtual environment setup or isolation questions arise |

## Quick Start

```bash
# 1. Create a virtual environment
python -m venv .venv

# 2. Activate the virtual environment
source .venv/bin/activate        # bash/zsh
# .venv\Scripts\Activate.ps1    # PowerShell

# 3. Install dependencies from requirements file
pip install -r requirements.txt

# 4. Capture installed packages to a requirements file
pip freeze > requirements.txt
```

## Core Command Tracks

- **Install package:** `pip install <pkg>` / `pip install "<pkg>>=1.2,<2"`
- **Install from file:** `pip install -r requirements.txt`
- **Editable install:** `pip install -e .` — links source directory directly
- **Uninstall:** `pip uninstall <pkg>`
- **List installed:** `pip list` / `pip list --outdated`
- **Show package info:** `pip show <pkg>`
- **Check deps:** `pip check` — verifies no broken requirements
- **Freeze:** `pip freeze > requirements.txt` — captures exact pinned versions
- **Download only:** `pip download -r requirements.txt -d ./vendor`

## Safety Guardrails

- Never install packages into the system Python; always activate a virtual environment first.
- Use `--require-hashes` in production requirements files to prevent supply-chain tampering.
- Avoid `--trusted-host` in production environments; configure proper TLS certificates instead.
- Pin exact versions (`==`) in deployment requirements to ensure reproducible installs.
- Run `pip check` after installs to surface dependency conflicts early.

```bash
# Troubleshoot dependency conflicts: check for broken requirements and show package info
pip check
pip show requests
pip list --outdated
```

## Related Skills

- **poetry** — dependency management and packaging with lock files and build system
- **pipenv** — combines pip and virtualenv with a `Pipfile` and lock file
- **ci-architecture** — caching pip installs and managing virtualenvs in CI/CD pipelines

## References

- `references/install-and-setup.md`
- `references/requirements-and-indexes.md`
- `references/command-cookbook.md`
- `references/virtual-environments.md`
- Official docs: <https://pip.pypa.io/en/stable/>
- User guide: <https://pip.pypa.io/en/stable/user_guide/>
- Requirements format: <https://pip.pypa.io/en/stable/reference/requirements-file-format/>
- PyPI: <https://pypi.org>
