---
name: yaml-linting
description: >
  Lint YAML files using yamllint in a Docker container.
  Validate YAML syntax, style, and configuration without installing yamllint locally.
---

# YAML Linting

Validate YAML files for syntax errors and style violations using yamllint in Docker.
This skill provides a containerized approach to linting YAML files without requiring local tool installation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Setup & Installation | `references/install-and-setup.md` | Getting started with Docker and yamllint |
| Quick Reference | `references/quick-reference.md` | Need common flags and commands |
| Configuration | `references/configuration.md` | Customizing linting rules |
| Troubleshooting | `references/troubleshooting.md` | Debugging linting errors |

---

## Quick Start

### Basic Linting Workflow

1. **Lint a single file** — Use Docker to run yamllint on a specific file
2. **Lint a directory** — Recursively lint all YAML files in a directory
3. **Apply custom rules** — Create a `.yamllint` config file in the project root

### Common Commands

```bash
# Lint a single file
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint /data/file.yml

# Lint entire directory
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint /data

# Lint with specific format (JSON, parsable)
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint -f parsable /data

# Lint with custom config
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint -c /data/.yamllint /data
```

### Configuration

yamllint automatically detects `.yamllint.yml` or `.yamllint` config files in the mounted directory.
Common rules include:

- `line-length`: Maximum line length (default 80)
- `indentation`: Indentation style (spaces, tabs)
- `truthy`: Enforce explicit `true`/`false` instead of `yes`/`no`

For detailed config options, load the Configuration reference.

---

## Exit Codes

| Code | Meaning |
| --- | --- |
| 0 | No errors found |
| 1 | Linting errors detected |
| 2 | Invalid configuration or unreadable files |

---

## Related References

- Load **Quick Reference** for command flags and common patterns
- Load **Configuration** to customize linting rules and extend yamllint
- Load **Troubleshooting** when linting fails or produces unexpected results
