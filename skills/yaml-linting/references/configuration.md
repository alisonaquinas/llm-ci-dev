# Configuration

Customize yamllint rules to match project standards.

## Configuration File

Place a `.yamllint` or `.yamllint.yml` file in the project root. yamllint automatically detects
and loads it when linting.

### Basic Structure

```yaml
---
extends: default

rules:
  line-length:
    max: 120
  indentation:
    spaces: 2
  truthy:
    allowed: ['true', 'false']
    check-keys: false
```

## Common Rules

### line-length

Control maximum line length:

```yaml
rules:
  line-length:
    max: 120        # Default is 80
    level: warning  # or error
```

### indentation

Enforce indentation style:

```yaml
rules:
  indentation:
    spaces: 2       # or 4, or consistent
    indent-sequences: true
    check-multi-line-strings: false
```

### truthy

Enforce explicit boolean values:

```yaml
rules:
  truthy:
    allowed: ['true', 'false']  # Disallow yes/no
    check-keys: false
```

### comments

Control comment formatting:

```yaml
rules:
  comments:
    min-spaces-from-content: 2
```

### key-duplicates

Detect duplicate keys:

```yaml
rules:
  key-duplicates: enable  # Always enabled
```

## Predefined Configurations

yamllint provides built-in rule sets:

- **default** — Standard rules (recommended starting point)
- **relaxed** — Lenient rules with fewer restrictions

### Using relaxed

```yaml
extends: relaxed
rules:
  line-length:
    max: 120
```

## Disabling Rules

Disable specific rules:

```yaml
rules:
  comments: disable
  trailing-spaces: disable
```

## Inline Configuration

Disable rules for specific lines:

```yaml
# yamllint disable-line rule:line-length
my-very-long-key: this is a very long line that would normally violate the rule

# yamllint disable rule:indentation
some-rule-disabled-section:
  key: value
# yamllint enable rule:indentation
```

## Examples

### Strict Configuration

```yaml
extends: default
rules:
  line-length: {max: 80}
  indentation: {spaces: 2, indent-sequences: true}
  truthy: {allowed: ['true', 'false'], check-keys: true}
```

### Relaxed Configuration

```yaml
extends: relaxed
rules:
  line-length: {max: 200}
  comments: disable
```
