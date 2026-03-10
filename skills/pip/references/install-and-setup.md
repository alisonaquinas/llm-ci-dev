# pip — Install and Setup

## Ensure pip is Available

pip is included with Python 3.4+. If it is missing, bootstrap it with:

```bash
python -m ensurepip --upgrade
```

## Upgrade pip

Always use the module form (`python -m pip`) to avoid PATH confusion:

```bash
python -m pip install --upgrade pip
```

Inside a virtual environment, `pip` and `python -m pip` refer to the same binary. Outside a venv, the module form ensures the correct Python interpreter is targeted.

## pip.conf / pip.ini Location

pip reads configuration from the following locations (later entries override earlier ones):

| Platform  | System-wide                        | User-level                         |
|-----------|------------------------------------|------------------------------------|
| Linux     | `/etc/pip.conf`                    | `~/.config/pip/pip.conf`           |
| macOS     | `/Library/Application Support/pip/pip.conf` | `~/Library/Application Support/pip/pip.conf` |
| Windows   | `C:\ProgramData\pip\pip.ini`       | `%APPDATA%\pip\pip.ini`            |

A project-level `pip.conf` inside a virtual environment (`$VIRTUAL_ENV/pip.conf`) is also supported.

## Common pip.conf Settings

```ini
[global]
# Default index (replaces PyPI)
index-url = https://pypi.org/simple/

# Additional index (searched after index-url)
extra-index-url = https://my-private-pypi.example.com/simple/

# Timeout in seconds
timeout = 60

# Disable version check warning
disable-pip-version-check = true

[install]
# Require a hash for every package (supply-chain hardening)
require-hashes = true
```

## Trusted Host (Use with Caution)

Allow connections to an HTTP (non-TLS) host. Only acceptable in isolated internal networks:

```ini
[global]
trusted-host = my-internal-pypi.corp
```

Never set `trusted-host` for public registries or production deployments.

## Verify Installation

```bash
python --version
python -m pip --version
```
