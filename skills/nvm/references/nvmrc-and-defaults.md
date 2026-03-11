# nvm: .nvmrc and Defaults

## .nvmrc Project File

`.nvmrc` is a plain-text file in a project's root directory that specifies the Node.js version for that project.

```bash
# Write the current version to .nvmrc
node --version > .nvmrc

# Or write a specific version
echo "20" > .nvmrc
echo "20.14.0" > .nvmrc
echo "lts/iron" > .nvmrc
```

Accepted formats: major (`20`), major.minor.patch (`20.14.0`), LTS codename (`lts/iron`), or `--lts`.

Commit `.nvmrc` to version control so all contributors automatically use the correct version.

## Using .nvmrc

```bash
# Install the version listed in .nvmrc (if not already installed)
nvm install

# Switch to the version listed in .nvmrc
nvm use

# Run a command with the version from .nvmrc
nvm run node app.js
nvm exec npm test
```

## default Alias

The `default` alias determines which Node version is active in a new shell session.

```bash
# Set default to a version
nvm alias default 20

# Set default to the latest LTS
nvm alias default lts/*

# View current default
nvm alias default
```

## Auto-Use on cd

nvm does not automatically switch versions on directory change by default. Add a shell function to enable this behaviour:

### bash / zsh

```bash
# Add to ~/.bashrc or ~/.zshrc
cdnvm() {
  builtin cd "$@" || return
  local nvm_path
  nvm_path="$(nvm_find_up .nvmrc | command tr -d '\n')"
  if [[ -e "${nvm_path}/.nvmrc" ]]; then
    nvm use
  elif [[ $(nvm current) != $(nvm version default) ]]; then
    nvm use default
  fi
}
alias cd='cdnvm'
```

An alternative is `avn` (<https://github.com/wbyoung/avn>) which handles auto-switching automatically.

## system Node Alias

The `system` alias refers to the Node.js installed outside of nvm (e.g. via Homebrew or the OS package manager):

```bash
# Switch to the system node
nvm use system

# Alias system node to a custom name
nvm alias my-system system
```
