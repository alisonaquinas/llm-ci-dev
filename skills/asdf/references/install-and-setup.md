# asdf Install & Setup

## Prerequisites

- Linux or macOS
- `git`, `curl`
- bash, zsh, fish, or other POSIX shell

## Install asdf

### Homebrew (macOS / Linux)

```bash
brew install asdf
```

### Git clone (Linux / macOS)

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
```

## Shell Integration

### bash

Add to `~/.bashrc`:

```bash
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
```

For Homebrew installs:

```bash
. "$(brew --prefix asdf)/libexec/asdf.sh"
```

### zsh

Add to `~/.zshrc`:

```bash
. "$HOME/.asdf/asdf.sh"
```

For Homebrew installs:

```bash
. "$(brew --prefix asdf)/libexec/asdf.sh"
```

### fish

```fish
# Run once to configure fish
echo "source (brew --prefix asdf)/libexec/asdf.fish" >> ~/.config/fish/config.fish
```

Reload the profile after editing:

```bash
source ~/.bashrc   # or ~/.zshrc
```

## Verify Installation

```bash
asdf version
# Expected: v0.14.0 or similar
```

## Plugin Ecosystem Overview

asdf manages tools via plugins. A plugin wraps the download, build, and shim logic for a specific tool. The community-maintained plugin registry is at <https://github.com/asdf-vm/asdf-plugins>.

Each tool requires its own plugin — see `references/plugins-and-tools.md` for common examples and the plugin lifecycle.
