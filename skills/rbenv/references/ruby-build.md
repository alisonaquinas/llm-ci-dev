# rbenv: ruby-build Plugin

## What Is ruby-build?

ruby-build is a plugin for rbenv (and a standalone tool) that compiles and installs Ruby versions from source. It is bundled with Homebrew's rbenv installation and installed to `~/.rbenv/plugins/ruby-build` by the rbenv-installer script.

## List Available Versions

```bash
# List stable Ruby releases
rbenv install --list

# List all versions including MRI, JRuby, TruffleRuby, etc.
rbenv install --list-all

# Filter to a specific major version
rbenv install --list-all | grep "^3\."
```

## Install Ruby

```bash
# Install with verbose output (useful for diagnosing build failures)
rbenv install --verbose 3.3.3

# Install to a custom path (standalone ruby-build)
ruby-build 3.3.3 ~/.rubies/3.3.3
```

## Build from Source with Custom Options

Use `RUBY_CONFIGURE_OPTS` to pass flags to the `./configure` step:

```bash
# Link against a specific OpenSSL (common on macOS with Homebrew)
RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)" rbenv install 3.3.3

# Enable jemalloc for better memory performance
RUBY_CONFIGURE_OPTS="--with-jemalloc" rbenv install 3.3.3
```

## Environment Variables

| Variable | Purpose |
| --- | --- |
| `RUBY_CONFIGURE_OPTS` | Extra flags passed to `./configure` |
| `RUBY_BUILD_CACHE_PATH` | Directory to cache downloaded source tarballs |
| `RUBY_BUILD_BUILD_PATH` | Temporary build directory |
| `MAKE_OPTS` / `MAKEOPTS` | Parallelism flag, e.g. `-j4` |

```bash
# Speed up compilation with parallel jobs
MAKE_OPTS="-j$(nproc)" rbenv install 3.3.3
```

## Update ruby-build Definitions

New Ruby versions require updated build definitions. Update ruby-build to access them:

```bash
# Homebrew
brew upgrade ruby-build

# Git clone install
cd ~/.rbenv/plugins/ruby-build && git pull
```

For advanced build troubleshooting, see: <https://github.com/rbenv/ruby-build#readme>
