# pip — Requirements Files and Indexes

## requirements.txt Format

Each line specifies a package, optionally with version constraints:

```text
# Exact pin (preferred for deployments)
requests==2.31.0

# Compatible release (allows patch updates)
boto3~=1.34.0

# Minimum version
flask>=3.0

# Version range
sqlalchemy>=2.0,<3

# Exclude a broken release
celery!=5.3.0,>=5.2

# Install from a VCS URL
git+https://github.com/org/repo.git@v1.2.3#egg=mypackage

# Include another requirements file
-r base.txt
```

## Version Specifier Summary

| Operator | Meaning                          | Example        |
|----------|----------------------------------|----------------|
| `==`     | Exact version                    | `pkg==1.2.3`   |
| `>=`     | Minimum version                  | `pkg>=1.2`     |
| `~=`     | Compatible release               | `pkg~=1.2.3`   |
| `!=`     | Exclude version                  | `pkg!=1.3.0`   |
| `<`      | Upper bound                      | `pkg<2`        |

## Constraints Files

Constraints files (`-c`) restrict versions of already-requested packages without adding new install requirements:

```bash
pip install -r requirements.txt -c constraints.txt
```

```text
# constraints.txt
certifi==2024.2.2
urllib3==2.2.1
```

Use constraints to lock transitive dependency versions without listing them as direct requirements.

## Index Configuration

```bash
# Replace PyPI with a private index
pip install mypackage --index-url https://private-pypi.example.com/simple/

# Add a secondary index (PyPI is still searched)
pip install mypackage --extra-index-url https://private-pypi.example.com/simple/
```

For persistent configuration, set these in `pip.conf` (see `install-and-setup.md`).

## Private PyPI Setup

Most private registries (Nexus, Artifactory, Google Artifact Registry, AWS CodeArtifact) expose a PEP 503-compatible `/simple/` endpoint. Authenticate via URL credentials or netrc:

```bash
pip install mypackage \
  --index-url https://user:token@private-pypi.example.com/simple/
```

Store credentials in `~/.netrc` instead of embedding them in URLs where possible.

## Hash Pinning (Supply-Chain Security)

Generate a requirements file with hashes using pip-tools:

```bash
pip-compile --generate-hashes requirements.in -o requirements.txt
```

Install with hash verification:

```bash
pip install --require-hashes -r requirements.txt
```

When `--require-hashes` is active, every package in the file must have a hash — pip rejects installs if any hash is missing or does not match.

## pip-tools Workflow

pip-tools separates abstract dependencies (`requirements.in`) from pinned lockfiles (`requirements.txt`):

```bash
# Install pip-tools
pip install pip-tools

# Compile a locked requirements file from abstract deps
pip-compile requirements.in

# Upgrade all packages to latest compatible versions
pip-compile --upgrade requirements.in

# Sync the virtual environment to exactly match the lockfile
pip-sync requirements.txt
```
