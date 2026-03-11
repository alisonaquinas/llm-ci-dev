# rvm Install & Setup

## Prerequisites

- Linux or macOS
- `curl` or `gpg2` (for signature verification)
- bash or zsh as the login shell

## Step 1: Import GPG Keys

rvm verifies the installer with GPG. Import the signing keys before installing:

```bash
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

If the keyserver is unreachable, import from the rvm keyserver:

```bash
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
```

## Step 2: Install rvm

```bash
# Install stable release
\curl -sSL https://get.rvm.io | bash -s stable

# Install stable release with Ruby pre-installed
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

The installer adds the rvm sourcing line to `~/.bashrc`, `~/.bash_profile`, or `~/.zshrc`.

## Step 3: Load rvm in the Current Shell

```bash
source ~/.rvm/scripts/rvm
```

Or close and reopen the terminal (rvm requires a login shell).

## Step 4: Install Build Requirements

```bash
rvm requirements
```

This installs OS-level build dependencies (e.g. `build-essential`, `libssl-dev` on Ubuntu).

## Verify Installation

```bash
rvm --version
# Expected: rvm 1.x.x (stable) ...
```

## Shell Integration Note

rvm must be loaded as a shell function (not a subprocess). In bash, ensure the terminal is a login shell, or source `~/.rvm/scripts/rvm` explicitly. In non-login shells, rvm commands may not be available.
