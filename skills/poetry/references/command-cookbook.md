# Command Cookbook — Poetry

## Project Initialization

```bash
# Scaffold a new project with directory structure
poetry new my-project

# Initialize Poetry in an existing directory (interactive)
poetry init
```

## Adding Dependencies

```bash
# Add a runtime dependency
poetry add requests

# Add to a specific group
poetry add --group dev pytest
poetry add --group test coverage

# Add with version constraint
poetry add "django>=4.2,<5.0"

# Add with extras
poetry add "uvicorn[standard]"
```

## Removing Dependencies

```bash
poetry remove requests
poetry remove --group dev pytest
```

## Installing Dependencies

```bash
# Install all dependencies (runtime + all groups)
poetry install

# Exclude dev dependencies (e.g., in production)
poetry install --without dev

# Install only specific groups
poetry install --only docs

# Skip installing the project package itself
poetry install --no-root
```

## Updating Dependencies

```bash
# Update all packages to latest compatible versions
poetry update

# Update a specific package
poetry update requests
```

## Inspecting Dependencies

```bash
# List installed packages
poetry show

# Show dependency tree
poetry show --tree

# Show info for a specific package
poetry show requests
```

## Building and Publishing

```bash
# Build wheel and sdist into dist/
poetry build

# Validate before publishing (no upload)
poetry publish --dry-run

# Publish to PyPI
poetry publish

# Publish to a private repository
poetry publish --repository my-private-repo
```

## Running Commands

```bash
# Run a command inside the virtual environment
poetry run python main.py
poetry run pytest

# Activate the virtual environment shell
poetry shell
```

## Virtual Environment Management

```bash
# Use a specific Python interpreter
poetry env use python3.11
poetry env use /usr/bin/python3.11

# List all managed virtual environments
poetry env list

# Show path to active virtual environment
poetry env info --path
```

## Exporting and Version Bumping

```bash
# Export to requirements.txt format
poetry export -f requirements.txt --output requirements.txt

# Export including dev group
poetry export --with dev -f requirements.txt --output requirements-dev.txt

# Bump version (patch / minor / major)
poetry version patch
poetry version minor
poetry version major
```

## Validation

```bash
# Validate pyproject.toml
poetry check
```
