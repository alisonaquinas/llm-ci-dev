# nvm Shell Integration

## How nvm Loads

nvm is a shell function, not a standalone binary. The installer appends a loader to the shell profile:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

This runs on every new shell, which adds a small startup delay. To reduce that, use lazy loading.

## Lazy-Loading Pattern

```bash
# ~/.bashrc or ~/.zshrc — replace the standard nvm loader
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() {
  unset -f node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}
```

With this pattern, nvm loads only when `nvm`, `node`, or `npm` is first invoked.

## zsh-specific Tips

zsh users can use the `zsh-nvm` plugin (<https://github.com/lukechilds/zsh-nvm>) for managed loading and auto-use support.

```zsh
# Oh-My-Zsh users: add to plugins array in ~/.zshrc
plugins=(... zsh-nvm)
```

## fish Shell

nvm does not support fish shell natively. Use one of these alternatives:

- **nvm.fish** — <https://github.com/jorgebucaran/nvm.fish> (pure fish implementation)
- **fnm** — <https://github.com/Schniz/fnm> (supports fish, reads `.nvmrc`)

```fish
# Install fnm for fish
curl -fsSL https://fnm.vercel.app/install | bash
fnm env --use-on-cd | source
```

## Windows Alternatives

nvm does not run on Windows. The closest alternatives are:

| Tool | URL | Notes |
| --- | --- | --- |
| nvm-windows | <https://github.com/coreybutler/nvm-windows> | Separate project, similar CLI surface |
| fnm | <https://github.com/Schniz/fnm> | Rust-based, cross-platform, reads `.nvmrc` |
| Volta | <https://volta.sh> | Tool-chain manager, per-project pinning |

All three support `.nvmrc` format for version pinning, so projects created with nvm work without changes.
