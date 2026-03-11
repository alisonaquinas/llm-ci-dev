# pyenv Project Files

## .python-version

`.python-version` is a plain-text file containing a Python version string (or virtualenv name). pyenv reads it automatically when entering a directory.

```bash
# Write .python-version for the current directory
pyenv local 3.12.3

# Write a virtualenv name instead of a bare version
pyenv local myapp-venv

# Verify
cat .python-version
# 3.12.3
```

Commit `.python-version` to version control so all contributors and CI use the same Python.

## Version Precedence

pyenv resolves the active Python in this order:

| Priority | Source | Set by |
| --- | --- | --- |
| 1 (highest) | `PYENV_VERSION` environment variable | `pyenv shell <version>` |
| 2 | `.python-version` in current or any parent directory | `pyenv local <version>` |
| 3 (lowest) | Global default (`~/.pyenv/version`) | `pyenv global <version>` |

```bash
# Inspect how the active version was resolved
pyenv version
# 3.12.3 (set by /path/to/project/.python-version)
```

## PYENV_VERSION Environment Variable

Set `PYENV_VERSION` directly in CI or scripts without writing a file:

```bash
PYENV_VERSION=3.11.9 python --version

# In CI (e.g. GitHub Actions)
- name: Set Python version
  run: echo "PYENV_VERSION=3.12.3" >> $GITHUB_ENV
```

## Multiple Python Versions for One Directory

A single `.python-version` can specify multiple space-separated versions. pyenv uses the first one as the default but makes all available:

```bash
pyenv local 3.12.3 3.11.9 3.10.14

# Now all three are available
python3.12 --version
python3.11 --version
tox   # tox discovers all configured versions
```

This is useful with `tox` for testing against multiple Python versions.

## Inspect and Manage .python-version

```bash
# Show the local version for the current directory
pyenv local

# Remove the local override (falls back to global)
pyenv local --unset

# Show the global version
pyenv global
```
