# pyenv: Virtual Environments (pyenv-virtualenv)

## What Is pyenv-virtualenv?

pyenv-virtualenv is a pyenv plugin that manages virtual environments alongside pyenv-managed Python versions. It integrates tightly with pyenv's version switching.

It is included automatically when pyenv is installed via `curl https://pyenv.run | bash`. For Homebrew installs:

```bash
brew install pyenv-virtualenv
```

Add to shell profile (if not already present from install-and-setup):

```bash
eval "$(pyenv virtualenv-init -)"
```

## Create a Virtualenv

```bash
# Create a virtualenv from a specific Python version
pyenv virtualenv 3.12.3 myapp

# The virtualenv name becomes a pyenv version alias
pyenv versions
# * system
#   3.12.3
#   3.12.3/envs/myapp
#   myapp -> /home/user/.pyenv/versions/3.12.3/envs/myapp
```

## Activate and Deactivate

```bash
# Activate manually
pyenv activate myapp

# Deactivate manually
pyenv deactivate
```

With `pyenv virtualenv-init -` in the shell profile, activation and deactivation happen automatically when entering/leaving a directory that has `.python-version` set to the virtualenv name.

## Pin a Virtualenv to a Directory

```bash
cd /path/to/project
pyenv local myapp
# Writes "myapp" to .python-version
# pyenv-virtualenv auto-activates the env when you enter this directory
```

## List and Delete Virtualenvs

```bash
# List all virtualenvs
pyenv virtualenvs

# Delete a virtualenv
pyenv virtualenv-delete myapp
# or equivalently
pyenv uninstall myapp
```

## Using with pip

Once the virtualenv is active, pip installs go into it:

```bash
pyenv activate myapp
pip install requests
pip list
pip freeze > requirements.txt
```

## Standard venv Alternative

pyenv also works with Python's built-in `venv` module:

```bash
pyenv local 3.12.3
python -m venv .venv
source .venv/bin/activate
```

This approach does not use pyenv-virtualenv but still uses the pyenv-managed Python binary.
