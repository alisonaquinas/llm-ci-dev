# pyenv Command Cookbook

## Install Python

```bash
# List all installable versions
pyenv install --list

# Filter to CPython 3.12.x
pyenv install --list | grep "  3.12"

# Install a specific version
pyenv install 3.12.3

# Install with verbose output (useful for build failures)
pyenv install --verbose 3.12.3
```

## Set Versions

```bash
# Set the global default
pyenv global 3.12.3

# Pin version for current directory (writes .python-version)
pyenv local 3.12.3

# Override for the current shell session only
pyenv shell 3.11.9

# Clear the shell override
pyenv shell --unset
```

## Inspect Active Version

```bash
# Show active version and where it was set
pyenv version

# List all installed versions (* = active)
pyenv versions

# Show the full path to the active python binary
pyenv which python

# Show the full path to pip
pyenv which pip
```

## Update pyenv

```bash
# Using pyenv-update plugin (installed with pyenv-installer)
pyenv update

# Using Homebrew
brew upgrade pyenv

# Using git
cd ~/.pyenv && git pull
```

## Uninstall a Version

```bash
pyenv uninstall 3.10.14
```

## Useful One-Liners

```bash
# Run a script under a specific Python without switching permanently
PYENV_VERSION=3.11.9 python --version

# Show the root of the pyenv installation
pyenv root

# Rebuild shims (needed after manually installing packages with binaries)
pyenv rehash

# Run a command with a specific Python
pyenv exec python --version
```
