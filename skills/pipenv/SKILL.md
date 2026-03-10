---
name: pipenv
description: Manage Python virtual environments and dependencies with Pipenv. Use when tasks mention pipenv commands, Pipfile, Pipfile.lock, virtual environment activation, or deterministic installs.
---

# Pipenv

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup, Python version selection | `references/install-and-setup.md` | Install Pipenv or configure the environment |
| Pipfile format, version specifiers, lock file | `references/pipfile-and-lockfile.md` | Configure Pipfile or understand lock file behavior |
| CLI commands, workflows | `references/command-cookbook.md` | Run install/sync/lock/check operations |
| Environment variables, .env loading, venv location | `references/environment-management.md` | Control venv placement or load environment variables |

## Quick Start

```bash
# Install packages (creates Pipfile and venv)
pipenv install requests

# Activate virtual environment shell
pipenv shell

# Run command in environment
pipenv run python app.py

# Install from Pipfile.lock (deterministic)
pipenv sync
```

## Core Command Tracks

- **Install package:** `pipenv install requests` — adds to `[packages]`, creates venv if absent
- **Install dev package:** `pipenv install --dev pytest` — adds to `[dev-packages]`
- **Activate shell:** `pipenv shell` — spawns a subprocess with the venv activated
- **Run one-off command:** `pipenv run python app.py` — without activating the shell
- **Deterministic install:** `pipenv sync` — installs exactly what is in `Pipfile.lock`
- **Regenerate lock file:** `pipenv lock` — resolves dependencies and writes `Pipfile.lock`
- **Security audit:** `pipenv check` — checks installed packages against known vulnerabilities
- **Dependency graph:** `pipenv graph` — prints the full dependency tree

## Safety Guardrails

- Set `PIPENV_VENV_IN_PROJECT=1` to place the virtual environment inside the project directory for portability and easier cleanup.
- Commit `Pipfile.lock` to version control to ensure reproducible installs in CI and on other machines.
- Use `pipenv check` regularly to surface security vulnerabilities in installed packages.
- Avoid running `pip install` directly inside a Pipenv-managed environment — use `pipenv install` to keep `Pipfile` and the lock file in sync.

## Workflow

1. Run `pipenv install <package>` to add runtime dependencies.
2. Run `pipenv install --dev <package>` to add development-only dependencies.
3. Run `pipenv lock` after manual edits to `Pipfile` to regenerate the lock file.
4. Run `pipenv sync` in CI to install the exact locked versions.
5. Commit both `Pipfile` and `Pipfile.lock`.

## Related Skills

- **poetry** — alternative tool using `pyproject.toml` with build and publish support
- **pip** — lower-level package installer used by Pipenv under the hood
- **ci-architecture** — integrating Pipenv into CI/CD pipelines

## References

- `references/install-and-setup.md`
- `references/pipfile-and-lockfile.md`
- `references/command-cookbook.md`
- `references/environment-management.md`
- Official docs: <https://pipenv.pypa.io/en/latest/>
- Pipfile spec: <https://github.com/pypa/pipfile>
- Security scanning: <https://pipenv.pypa.io/en/latest/advanced/#detection-of-security-vulnerabilities>
