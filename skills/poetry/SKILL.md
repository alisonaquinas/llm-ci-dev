---
name: poetry
description: Manage Python project dependencies, virtual environments, and package builds with Poetry. Use when tasks mention poetry commands, pyproject.toml configuration, dependency groups, or publishing packages to PyPI.
---

# Poetry

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup, shell completions | `references/install-and-setup.md` | Install Poetry or configure the environment |
| pyproject.toml fields, version constraints, extras | `references/pyproject-toml.md` | Configure project metadata or dependency specs |
| CLI commands, workflows | `references/command-cookbook.md` | Run add/remove/install/build/publish operations |
| Dependency groups, optional groups | `references/dependency-groups.md` | Define or install dev/test/docs dependency groups |

## Quick Start

```bash
# Create new project
poetry new my-project

# Add dependency
poetry add requests

# Install all dependencies
poetry install

# Run in virtual environment
poetry run python main.py
```

## Core Command Tracks

- **New project:** `poetry new my-project` — scaffold with pyproject.toml and package directory
- **Init in existing dir:** `poetry init` — interactive pyproject.toml creation
- **Add dependency:** `poetry add requests` — adds and installs, updates lock file
- **Add dev dependency:** `poetry add --group dev pytest` — scoped to dev group
- **Install project:** `poetry install` — installs all dependencies from lock file
- **Update dependencies:** `poetry update` — resolves newest compatible versions
- **Build distribution:** `poetry build` — produces wheel and sdist in `dist/`
- **Publish to PyPI:** `poetry publish --dry-run` — validate before publishing

## Safety Guardrails

- Poetry creates an isolated virtual environment by default — avoid installing into the system Python.
- Passing `--no-root` skips installing the project package itself; use only when running in CI with no editable install needed.
- Commit `poetry.lock` to version control to ensure reproducible installs across environments.
- Use `poetry env use /path/to/python` to pin a specific Python interpreter for a project.
- Run `poetry check` before publishing to validate pyproject.toml consistency.

## Workflow

1. Define project metadata and dependencies in `pyproject.toml`.
2. Run `poetry install` to create the virtual environment and install all packages.
3. Use `poetry add` / `poetry remove` to keep the lock file up to date.
4. Run `poetry build` then `poetry publish --dry-run` before any release.
5. Commit both `pyproject.toml` and `poetry.lock`.

```bash
# Troubleshoot environment issues: inspect the venv path and check dependency resolution
poetry env info
poetry check
poetry show --tree
```

## Related Skills

- **pipenv** — alternative workflow combining pip and virtualenv into one tool
- **pip** — lower-level package installer used by Poetry under the hood
- **ci-architecture** — integrating Poetry into CI/CD pipelines

## References

- `references/install-and-setup.md`
- `references/pyproject-toml.md`
- `references/command-cookbook.md`
- `references/dependency-groups.md`
- Official docs: <https://python-poetry.org/docs/>
- PyPI publishing guide: <https://python-poetry.org/docs/repositories/>
- Dependency specification: <https://python-poetry.org/docs/dependency-specification/>
