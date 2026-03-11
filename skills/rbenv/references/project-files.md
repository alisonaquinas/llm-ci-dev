# rbenv Project Files

## .ruby-version

`.ruby-version` is a plain-text file containing a single Ruby version string. rbenv reads it automatically when entering a directory, making it the standard mechanism for per-project version pinning.

```bash
# Write .ruby-version for the current directory
rbenv local 3.3.3

# Verify the file was written
cat .ruby-version
# 3.3.3
```

Commit `.ruby-version` to version control. rvm, chruby, and other Ruby version managers also read this file, ensuring cross-tool compatibility.

## Version Precedence

rbenv resolves the active Ruby in this order (highest priority first):

| Priority | Source | Set by |
| --- | --- | --- |
| 1 (highest) | `RBENV_VERSION` environment variable | `rbenv shell <version>` |
| 2 | `.ruby-version` in current directory or any parent | `rbenv local <version>` |
| 3 (lowest) | Global default | `rbenv global <version>` |

```bash
# Inspect how the active version was resolved
rbenv version
# 3.3.3 (set by /path/to/project/.ruby-version)
```

## Inspect and Manage .ruby-version

```bash
# Show the local version for the current directory
rbenv local

# Remove the local override (falls back to global)
rbenv local --unset

# Show the global version
rbenv global

# Show which version a command like 'ruby' resolves to
rbenv which ruby
```

## RBENV_VERSION Environment Variable

For scripting or CI pipelines, set `RBENV_VERSION` directly without writing a file:

```bash
RBENV_VERSION=3.2.4 ruby --version
RBENV_VERSION=3.2.4 bundle exec rake spec
```

This is useful in CI when the version is determined by a matrix variable rather than a committed `.ruby-version`.

## Multiple .ruby-version Files (Monorepos)

In a monorepo, each subdirectory can have its own `.ruby-version`. rbenv searches parent directories up to the filesystem root, so a service at `services/api/.ruby-version` takes precedence over the root `.ruby-version` when working inside that directory.
