# Pipfile and Pipfile.lock — Pipenv

## Pipfile Format

A `Pipfile` has four main sections:

```toml
[[source]]
url = "https://pypi.org/simple"
verify_ssl = true
name = "pypi"

[packages]
requests = "*"
django = ">=4.2,<5.0"
celery = { version = "^5.3", extras = ["redis"] }

[dev-packages]
pytest = "*"
black = ">=24.0"
ruff = "*"

[requires]
python_version = "3.11"
```

## Version Specifiers

| Specifier | Meaning |
| --- | --- |
| `"*"` | Any version |
| `">=2.0"` | Minimum version |
| `">=2.0,<3.0"` | Range |
| `"==1.4.2"` | Exact pin |
| `"~=1.4.2"` | Compatible release (patch-level) |

Pipenv also supports PEP 508 markers:

```toml
[packages]
pywin32 = { version = "*", markers = "sys_platform == 'win32'" }
```

## Extras

```toml
[packages]
uvicorn = { version = "*", extras = ["standard"] }
```

## Pipfile.lock Structure and Purpose

`Pipfile.lock` is a machine-generated JSON file that records the exact resolved version
and cryptographic hash of every package (direct and transitive).

Key fields in the lock file:

- `"default"` — runtime packages with pinned versions and hashes
- `"develop"` — dev packages with pinned versions and hashes
- `"_meta"` — hash of `Pipfile`, Python info, source URLs

Example entry:

```json
"requests": {
    "hashes": [
        "sha256:abc123..."
    ],
    "version": "==2.31.0"
}
```

## When to Commit Pipfile.lock

Always commit `Pipfile.lock` to version control. This guarantees that every developer,
CI run, and deployment uses identical package versions, preventing "works on my machine"
dependency drift.

## Regenerating the Lock File

```bash
# Resolve and regenerate without installing
pipenv lock

# Install from the existing lock file (no resolution)
pipenv sync
```
