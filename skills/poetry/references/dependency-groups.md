# Dependency Groups — Poetry

## Defining Groups in pyproject.toml

Use `[tool.poetry.group.<name>.dependencies]` to declare named groups:

```toml
[tool.poetry.group.dev.dependencies]
pytest = "^8.0"
ruff = "^0.4"
mypy = "^1.10"

[tool.poetry.group.docs.dependencies]
sphinx = "^7.0"
furo = "^2024.1"

[tool.poetry.group.test.dependencies]
coverage = { version = "^7.0", extras = ["toml"] }
pytest-cov = "^5.0"
```

## Optional Groups

Mark a group as optional so it is not installed by default:

```toml
[tool.poetry.group.docs]
optional = true

[tool.poetry.group.docs.dependencies]
sphinx = "^7.0"
```

Install an optional group explicitly:

```bash
poetry install --with docs
```

## Installing / Excluding Groups

```bash
# Install everything (all non-optional groups)
poetry install

# Include specific optional groups
poetry install --with docs,test

# Exclude a normally-installed group
poetry install --without dev

# Install only one group (and the project itself)
poetry install --only test

# Install only dependencies, not the project package
poetry install --only-root
```

## Exporting Groups

```bash
# Export runtime + dev group to requirements.txt
poetry export --with dev -f requirements.txt --output requirements-dev.txt
```

## Adding to a Group via CLI

```bash
poetry add --group dev black
poetry add --group docs sphinx
```

## Migrating from Legacy dev-dependencies

The old `[tool.poetry.dev-dependencies]` block is equivalent to `[tool.poetry.group.dev.dependencies]`.
Migrate by moving packages into the new group syntax; both coexist but the group syntax is preferred.

```toml
# Before (legacy)
[tool.poetry.dev-dependencies]
pytest = "^8.0"

# After (preferred)
[tool.poetry.group.dev.dependencies]
pytest = "^8.0"
```

Running `poetry install` treats both formats identically during the transition.
