# Command Cookbook — Pipenv

## Installing Packages

```bash
# Install a runtime package (adds to [packages])
pipenv install requests

# Install a dev-only package (adds to [dev-packages])
pipenv install --dev pytest

# Install from Pipfile.lock exactly (no resolution)
pipenv sync

# Install all packages including dev
pipenv sync --dev

# Install from existing Pipfile (resolves and installs)
pipenv install
```

## Uninstalling Packages

```bash
pipenv uninstall requests
pipenv uninstall --dev pytest
```

## Regenerating the Lock File

```bash
# Resolve all dependencies and write Pipfile.lock
pipenv lock

# Lock only runtime dependencies
pipenv lock --keep-outdated
```

## Running Commands

```bash
# Run a single command inside the virtual environment
pipenv run python app.py
pipenv run pytest
pipenv run gunicorn myapp:app

# Activate the virtual environment shell interactively
pipenv shell

# Exit the activated shell
exit
```

## Dependency Graph

```bash
# Print full dependency tree
pipenv graph

# Show reverse dependencies (who requires a package)
pipenv graph --reverse
```

## Security Audit

```bash
# Check installed packages for known vulnerabilities
pipenv check
```

## Updating Packages

```bash
# Update all packages to latest compatible versions
pipenv update

# Update a specific package
pipenv update requests
```

## Cleaning Unused Packages

```bash
# Remove packages not in Pipfile
pipenv clean
```

## Environment Paths

```bash
# Show the project's root directory
pipenv --where

# Show the virtual environment path
pipenv --venv

# Show the Python interpreter path
pipenv --py
```

## Removing the Virtual Environment

```bash
pipenv --rm
```
