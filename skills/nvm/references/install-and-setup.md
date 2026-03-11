# nvm Install & Setup

## Prerequisites

- A POSIX-compatible shell: bash, zsh, ksh, or dash
- `curl` or `wget` (used by the installer)
- macOS or Linux (for Windows, see the Windows Alternatives note below)

## Install nvm

### macOS / Linux (curl)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

### macOS / Linux (wget)

```bash
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

The installer clones the nvm repository to `~/.nvm` and appends the shell integration snippet to the appropriate profile file.

## Shell Profile Integration

The installer automatically appends this snippet. If it is missing, add it manually:

```bash
# ~/.bashrc or ~/.zshrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

After editing the profile, reload it:

```bash
source ~/.bashrc   # or ~/.zshrc
```

## Verify Installation

```bash
nvm --version
# Expected output: 0.40.1 (or installed version)
```

If `nvm: command not found`, the shell profile was not sourced. Close and reopen the terminal or source the profile.

## Windows Note

nvm does not support Windows natively. Use one of these alternatives instead:

- **nvm-windows** — <https://github.com/coreybutler/nvm-windows> (separate project, similar CLI)
- **fnm** — <https://github.com/Schniz/fnm> (cross-platform, Rust-based, supports `.nvmrc`)

Both tools support `.nvmrc` files so projects created with nvm work without changes.
