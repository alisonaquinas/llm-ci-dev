# rbenv Install & Setup

## Prerequisites

- macOS or Linux
- A C compiler and build tools (for compiling Ruby via ruby-build)
- Homebrew (macOS) or Git (Linux)

## Install on macOS (Homebrew)

```bash
brew install rbenv ruby-build

# Initialise rbenv in the shell
rbenv init
```

Follow the printed instructions to add the init snippet to `~/.zshrc` or `~/.bash_profile`.

## Install on Linux (rbenv-installer)

```bash
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
```

The installer clones rbenv and ruby-build to `~/.rbenv` and verifies the installation.

### Manual install (alternative)

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

## Shell Integration

Add the following to `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"   # or: eval "$(rbenv init - zsh)"
```

Reload the profile:

```bash
source ~/.bashrc   # or ~/.zshrc
```

## Verify Installation

```bash
rbenv --version
# Expected: rbenv x.y.z (date: ...)

rbenv doctor   # checks for common configuration issues
```

## Install Build Dependencies (Linux)

Before installing Ruby, install the required build packages:

```bash
# Ubuntu / Debian
sudo apt-get install -y build-essential libssl-dev libreadline-dev zlib1g-dev \
  libyaml-dev libffi-dev libgdbm-dev libncurses5-dev

# Fedora / RHEL
sudo dnf install -y openssl-devel readline-devel zlib-devel libyaml-devel
```
