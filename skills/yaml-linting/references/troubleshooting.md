# Troubleshooting

Resolve common yamllint issues.

## Image Not Found

**Error:** `Unable to find image 'pipelinecomponents/yamllint:latest'`

**Solution:** Pull the image first:

```bash
docker pull pipelinecomponents/yamllint
```

## Parse Errors

**Error:** `while parsing a flow mapping` or similar YAML syntax errors

**Cause:** Malformed YAML syntax (missing colons, quotes, indentation)

**Solution:** Check the file for common issues:

```bash
# View the problematic line
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint \
  yamllint -f parsable /data/file.yml | head -20
```

Fix issues like:

- Missing colons after keys: `key value` → `key: value`
- Inconsistent indentation: Mix of spaces and tabs
- Unclosed quotes or brackets

## Configuration Not Found

**Error:** `yamllint: config file is not a file: /data/.yamllint`

**Cause:** Config file path is incorrect or file doesn't exist

**Solution:** Verify the config file exists in the mounted directory:

```bash
# Check current directory for config
ls -la .yamllint*

# Use explicit config path
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint \
  yamllint -c /data/.yamllint.yml /data
```

## Volume Mount Issues

**Error:** `docker: Error response from daemon: invalid mount config`

**Cause:** Incorrect path syntax or Docker not running

**Solution:** Verify Docker is running and paths are absolute:

```bash
# Use pwd to get absolute path
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint --version

# On Windows with Git Bash, prepend with /c/ or use full path
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint /data
```

## Line Length Violations

**Error:** `line too long` (trailing-spaces, line-length)

**Solution:** Either adjust the file or config:

```yaml
# In .yamllint, increase limit
rules:
  line-length:
    max: 120

# Or disable for specific lines
# yamllint disable-line rule:line-length
long-key: "very long value that exceeds normal limits"
```

## Indentation Errors

**Error:** `wrong indentation: expected N but found M`

**Cause:** Inconsistent spacing (mixing spaces/tabs or wrong indent size)

**Solution:** Fix indentation in the file:

```yaml
# Wrong
key:
  subkey: value    # 2 spaces
  other:    value  # 4 spaces (inconsistent)

# Correct
key:
  subkey: value
  other: value
```

## Permission Denied

**Error:** `Permission denied` when mounting volumes

**Cause:** File permissions or Docker daemon access

**Solution:** Ensure files are readable:

```bash
chmod +r file.yml
# Or run with appropriate Docker context
```

## Empty Results

**Problem:** Linting completes but shows no output

**Solution:** Verify files are being found:

```bash
# List files in container
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint \
  ls -la /data

# Check if YAML files exist
find . -name "*.yml" -o -name "*.yaml"
```
