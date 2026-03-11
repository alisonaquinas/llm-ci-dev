# pyenv Install & Setup

## Prerequisites

- Linux or macOS
- Build dependencies for compiling Python from source (see below)
- bash, zsh, or fish shell

## Install Build Dependencies

Python is compiled from source — build dependencies must be installed first.

### Ubuntu / Debian

```bash
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl git \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev
```

### macOS (Homebrew dependencies)

```bash
brew install openssl readline sqlite3 xz zlib tcl-tk
```

## Install pyenv

### pyenv-installer (Linux / macOS)

```bash
curl https://pyenv.run | bash
```

This installs pyenv, pyenv-update, pyenv-doctor, and pyenv-virtualenv.

### Homebrew (macOS)

```bash
brew install pyenv
```

## Shell Integration

Add the following to `~/.bashrc` or `~/.zshrc`:

```bash
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

For pyenv-virtualenv, also add:

```bash
eval "$(pyenv virtualenv-init -)"
```

Reload the profile:

```bash
source ~/.bashrc   # or ~/.zshrc
```

## Verify Installation

```bash
pyenv --version
# Expected: pyenv x.y.z

pyenv doctor   # checks for common issues
```
