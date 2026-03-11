# direnv Install & Setup

## Prerequisites

- Linux, macOS, or Windows (WSL)
- bash, zsh, fish, tcsh, or elvish shell

## Install direnv

### macOS (Homebrew)

```bash
brew install direnv
```

### Ubuntu / Debian

```bash
sudo apt-get install direnv
```

### Fedora / RHEL

```bash
sudo dnf install direnv
```

### Nix

```bash
nix-env -i direnv
```

### Binary release (any Linux/macOS)

Download the latest release from <https://github.com/direnv/direnv/releases> and place it in a directory on `PATH`.

## Shell Hook

After installing, add the shell hook to the profile so direnv loads automatically:

### bash

```bash
# ~/.bashrc
eval "$(direnv hook bash)"
```

### zsh

```zsh
# ~/.zshrc
eval "$(direnv hook zsh)"
```

### fish

```fish
# ~/.config/fish/config.fish
direnv hook fish | source
```

### tcsh

```tcsh
# ~/.tcshrc
eval `direnv hook tcsh`
```

Reload the profile after editing:

```bash
source ~/.bashrc   # or ~/.zshrc
```

## Verify Installation

```bash
direnv version
# Expected: 2.x.x
```

## .envrc Security Model

direnv does not execute `.envrc` files automatically the first time they are encountered or after they change. The file must be explicitly allowed:

```bash
direnv allow
```

This design prevents malicious `.envrc` files in untrusted directories from executing arbitrary code. The allowed file hash is stored in `~/.local/share/direnv/allow/`.

Always review `.envrc` contents before running `direnv allow`.
