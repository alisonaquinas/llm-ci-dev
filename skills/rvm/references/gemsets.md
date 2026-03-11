# rvm Gemsets

## What Are Gemsets?

Gemsets are isolated gem sandboxes associated with a specific Ruby version. Each gemset has its own gem directory, so projects can use different gem versions without conflicts.

## Create and Use a Gemset

```bash
# Create a gemset
rvm gemset create myapp

# Switch to ruby version + gemset
rvm use 3.3.0@myapp

# Shorthand: create and use in one step
rvm use --create 3.3.0@myapp
```

## List and Inspect Gemsets

```bash
# List gemsets for the current Ruby
rvm gemset list

# List gemsets for a specific Ruby
rvm gemset list_all

# Show the active gemset
rvm gemset name

# Show where gems are installed
gem env home
```

## Delete Gemsets

```bash
# Delete the named gemset (current Ruby)
rvm gemset delete myapp

# Empty a gemset without deleting it
rvm gemset empty myapp
```

## @global Gemset

The `@global` gemset is shared across all gemsets for a given Ruby version. Gems installed here are available in every project gemset.

```bash
# Switch to the global gemset for current Ruby
rvm gemset use global

# Install a gem globally (available to all projects on this Ruby)
gem install bundler

# Install to global explicitly
rvm @global do gem install rake
```

Bundler is typically installed into `@global` so every project gemset can use it without re-installing.

## Gemset-Aware Bundler

When using a gemset, run `bundle install` normally — gems install into the active gemset:

```bash
rvm use 3.3.0@myapp
bundle install   # installs into the myapp gemset
bundle exec rails server
```

## Copy Gemsets

```bash
# Copy gems from one gemset to another
rvm gemset copy 3.3.0@myapp 3.3.0@myapp-backup
```
