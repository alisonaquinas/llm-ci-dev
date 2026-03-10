# Quick Reference

Common yamllint commands and flags.

## Basic Commands

```bash
# Lint a single file
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint /data/file.yml

# Lint entire directory
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint /data

# Lint with parsable format (for CI/CD)
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint -f parsable /data

# Lint with JSON output
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint -f json /data
```

## Common Flags

| Flag | Purpose |
| --- | --- |
| `-d <config>` | Use specific config string or file |
| `-f <format>` | Output format: `parsable`, `json`, `standard` (default) |
| `-s` | Print rule specification |
| `--print-config` | Print effective configuration and exit |

## Format Options

- **standard** — Human-readable output (default)
- **parsable** — Machine-readable format suitable for CI/CD pipelines
- **json** — JSON output for programmatic processing

## Exit Codes

| Code | Meaning |
| --- | --- |
| 0 | No issues found |
| 1 | Linting errors detected |
| 2 | Configuration or argument error |

## Common Use Cases

### Lint with specific configuration

```bash
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint \
  yamllint -d "{extends: default, rules: {line-length: {max: 120}}}" /data
```

### Check configuration without linting

```bash
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint \
  yamllint --print-config /data
```

### Lint in GitHub Actions

```yaml
- name: Lint YAML
  run: |
    docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint \
      yamllint -f parsable /data
```
