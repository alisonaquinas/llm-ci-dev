# Install and Setup — Pipenv

## Install via pip (User Install)

```bash
pip install --user pipenv
```

Ensure `~/.local/bin` is on `PATH` so the `pipenv` binary is accessible.

## Install via Homebrew (macOS / Linux)

```bash
brew install pipenv
```

## Check Installed Version

```bash
pipenv --version
```

## Python Version Selection

Specify the Python interpreter when creating a new environment:

```bash
# Use Python 3.11
pipenv --python 3.11

# Use an explicit path
pipenv --python /usr/local/bin/python3.12
```

The selected version is recorded in the `[requires]` section of `Pipfile`:

```toml
[requires]
python_version = "3.11"
```

## PIPENV_VENV_IN_PROJECT

Place the virtual environment inside the project directory (`.venv/`) instead of a
global cache location. Set this in the shell profile or in CI environment variables:

```bash
export PIPENV_VENV_IN_PROJECT=1
```

This makes the environment portable, easier to inspect, and consistent with tools
like Docker that mount the project directory.

## PIPENV_PYTHON Environment Variable

Override the default Python interpreter without passing `--python` each time:

```bash
export PIPENV_PYTHON=python3.11
```

## Upgrading Pipenv

```bash
pip install --user --upgrade pipenv
# or
brew upgrade pipenv
```
