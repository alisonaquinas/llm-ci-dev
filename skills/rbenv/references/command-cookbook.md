# rbenv Command Cookbook

## Install Ruby

```bash
# List installable versions
rbenv install --list          # stable releases
rbenv install --list-all      # all versions including pre-releases

# Install a specific version
rbenv install 3.3.3

# Install and set as global default in one step
rbenv install 3.3.3 && rbenv global 3.3.3
```

## Set Versions

```bash
# Set global default (used when no local version is set)
rbenv global 3.3.3

# Pin version for the current directory (writes .ruby-version)
rbenv local 3.3.3

# Override for the current shell session only
rbenv shell 3.2.4

# Clear the shell override
rbenv shell --unset
```

## Inspect Active Version

```bash
# Show active version and where it was set (local/global/shell)
rbenv version

# List all installed versions (* = active)
rbenv versions

# Show the full path to the active ruby binary
which ruby

# Confirm with ruby itself
ruby --version
```

## Rehash Shims

After installing a gem that provides a CLI binary, rehash to register the shim:

```bash
rbenv rehash
```

Bundler's binstubs trigger this automatically when using `bundle exec`.

## Remove a Version

```bash
rbenv uninstall 3.1.6

# Non-interactive (skip confirmation)
rbenv uninstall -f 3.1.6
```

## Useful One-Liners

```bash
# Run a command under a specific Ruby without switching permanently
RBENV_VERSION=3.2.4 ruby --version

# Show where rbenv will find ruby for a directory
rbenv which ruby

# Show the root of the rbenv installation
rbenv root

# List all rbenv commands
rbenv commands
```
