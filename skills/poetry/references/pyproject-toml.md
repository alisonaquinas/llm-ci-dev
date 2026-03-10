# pyproject.toml — Poetry

## [tool.poetry] Section

Core project metadata:

```toml
[tool.poetry]
name = "my-package"
version = "0.1.0"
description = "A short description of the project"
authors = ["Jane Smith <jane@example.com>"]
license = "MIT"
readme = "README.md"
homepage = "https://example.com"
repository = "https://github.com/example/my-package"
keywords = ["packaging", "example"]
classifiers = ["Topic :: Software Development"]
```

## Python Version Constraint

```toml
[tool.poetry.dependencies]
python = "^3.10"
```

## Version Constraint Operators

| Operator | Meaning | Example |
| --- | --- | --- |
| `^` | Compatible release (allows minor/patch bumps) | `^2.1.0` → `>=2.1.0 <3.0.0` |
| `~` | Patch-level compatible | `~2.1.0` → `>=2.1.0 <2.2.0` |
| `*` | Wildcard | `2.*` → `>=2.0.0 <3.0.0` |
| `>=` | Minimum bound | `>=1.4` |
| `!=` | Exclusion | `!=1.3.2` |

## Dependencies

```toml
[tool.poetry.dependencies]
python = "^3.10"
requests = "^2.31"
sqlalchemy = { version = "^2.0", extras = ["asyncio"] }
```

## Dev Dependencies (Legacy Style)

```toml
[tool.poetry.dev-dependencies]
pytest = "^8.0"
```

This style is still supported but the group syntax below is preferred.

## Dependency Groups (Preferred)

```toml
[tool.poetry.group.dev.dependencies]
pytest = "^8.0"
ruff = "^0.4"
```

## Scripts / Entry Points

```toml
[tool.poetry.scripts]
my-cli = "my_package.cli:main"
```

## Extras

```toml
[tool.poetry.extras]
docs = ["sphinx", "furo"]
```

Install with: `poetry install --extras docs`

## Build System

Always include the build backend declaration:

```toml
[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```
