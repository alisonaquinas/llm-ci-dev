# rvm Command Cookbook

## Install Ruby

```bash
# Install latest stable Ruby
rvm install ruby

# Install a specific version
rvm install 3.3.0

# Install Ruby with a specific OpenSSL version
rvm install 3.3.0 --with-openssl-dir=$(brew --prefix openssl)

# List known installable versions
rvm list known
```

## Switch Versions

```bash
# Switch to an installed version
rvm use 3.3.0

# Switch and make default for new shells
rvm use 3.3.0 --default

# Switch to system Ruby (outside rvm)
rvm use system
```

## List Rubies

```bash
# List installed rubies (current marked with =>)
rvm list

# List all known installable versions
rvm list known
```

## Current Version

```bash
# Show active ruby and gemset
rvm current

# Show just the ruby version
ruby --version
```

## Gemsets

```bash
# Create a gemset
rvm gemset create myapp

# Use a version + gemset combination
rvm use 3.3.0@myapp

# List gemsets for the current Ruby
rvm gemset list

# Delete a gemset
rvm gemset delete myapp

# Show gems in the current gemset
gem list
```

## Uninstall / Remove

```bash
# Remove a Ruby version (keeps gemsets)
rvm remove 3.1.0

# Completely uninstall including gemsets
rvm uninstall 3.1.0
```

## Useful One-Liners

```bash
# Run a command with a specific ruby without switching permanently
rvm 3.2.0 do ruby --version
rvm 3.2.0@mygemset do bundle exec rake

# Reload rvm (useful after editing shell config)
rvm reload

# Check rvm environment
rvm env
```
