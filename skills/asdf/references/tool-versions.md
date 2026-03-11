# asdf: .tool-versions

## What Is .tool-versions?

`.tool-versions` is a plain-text file that specifies the tool versions for a directory. asdf reads it automatically when entering a directory.

## File Format

```text
nodejs 20.14.0
python 3.12.3
ruby 3.3.3
golang 1.22.4
```

Rules:
- One tool per line: `<tool-name> <version>`
- Comments with `#` are supported
- Multiple versions per line are supported (the first is the default)

```text
# .tool-versions
nodejs 20.14.0 18.20.3   # two versions; 20.14.0 is active
python 3.12.3
```

## Managing .tool-versions with Commands

```bash
# Write a tool version to .tool-versions in the current directory
asdf local nodejs 20.14.0

# Write to the global ~/.tool-versions
asdf global nodejs 20.14.0

# Install all versions listed in the nearest .tool-versions
asdf install
```

## Version Precedence

| Priority | Source |
| --- | --- |
| 1 (highest) | `ASDF_${TOOL}_VERSION` environment variable |
| 2 | `.tool-versions` in current directory |
| 3 | `.tool-versions` in any parent directory |
| 4 (lowest) | `~/.tool-versions` (global) |

## Committing to Source Control

Commit `.tool-versions` to version control so all contributors and CI use the same versions:

```bash
git add .tool-versions
git commit -m "chore: pin tool versions"
```

## CI Usage

### GitHub Actions

```yaml
- name: Install asdf
  uses: asdf-vm/actions/setup@v3

- name: Install tool versions
  uses: asdf-vm/actions/install@v3
  # Reads .tool-versions automatically
```

### Generic CI

```bash
# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
. ~/.asdf/asdf.sh

# Add required plugins
asdf plugin add nodejs
asdf plugin add python

# Install all versions from .tool-versions
asdf install
```

## Interoperability

asdf also reads `.node-version` (fallback for Node.js), but `.tool-versions` is the canonical file and the only format that supports multiple tools in a single file.
