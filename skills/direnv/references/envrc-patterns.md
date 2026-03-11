# direnv: .envrc Patterns

## Basic Exports

```bash
# .envrc
export APP_ENV=development
export DATABASE_URL=postgres://localhost/myapp_dev
export PORT=3000
```

## PATH Manipulation

```bash
# Add a directory to the front of PATH (relative to .envrc location)
PATH_add bin
PATH_add scripts

# Add a directory using an absolute path
PATH_add /opt/my-tool/bin
```

`PATH_add` is a direnv stdlib function that prepends the directory to `PATH` and removes it when leaving.

## Source Other Files

```bash
# Source another .envrc (relative path)
source_env ../shared/.envrc

# Source only if the file exists
source_env_if_exists .envrc.local
```

## Layout Functions

`layout` activates a language-specific environment:

### Python (stdlib venv)

```bash
# Create/activate a virtualenv in .direnv/python-<version>/
layout python3
```

### Python with pyenv

```bash
# Use pyenv-managed Python and create a virtualenv
layout pyenv 3.12.3
```

### Ruby

```bash
# Use the ruby version from .ruby-version and set GEM_HOME
layout ruby
```

### Node.js

```bash
# Add node_modules/.bin to PATH
layout node
```

## use Command

`use` loads a version-manager integration:

```bash
# asdf integration
use asdf

# nvm integration (requires nvm.sh to be sourced first)
use nvm 20
```

## dotenv Files

```bash
# Load variables from a .env file
dotenv

# Load a named dotenv file
dotenv .env.local
```

Variables in `.env` do not need `export` — direnv exports them automatically.

## Conditional Exports

```bash
# Only export if the variable is not already set
: ${MY_VAR:=default_value}
export MY_VAR

# Export based on OS
if [[ "$(uname)" == "Darwin" ]]; then
  export MACOS_ONLY=yes
fi
```

## Template: Typical Project .envrc

```bash
# .envrc
# Load local overrides (not committed to VCS)
source_env_if_exists .envrc.local

# Language version
use asdf

# Application config
export APP_ENV=development
export LOG_LEVEL=debug

# Add project scripts to PATH
PATH_add bin
```
