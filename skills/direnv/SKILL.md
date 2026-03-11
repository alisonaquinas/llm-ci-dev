---
name: direnv
description: Manage per-directory environment variables with direnv. Use when tasks mention direnv, .envrc, per-directory environment variables, or automatic environment switching.
---

# direnv

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| apt/brew/nix install, shell hook, .envrc security model | `references/install-and-setup.md` | direnv needs to be installed or the shell hook is missing |
| allow/deny/reload/edit/status/prune commands | `references/command-cookbook.md` | Specific direnv commands are needed |
| export, PATH_add, source_env, layout, use commands | `references/envrc-patterns.md` | Writing or debugging .envrc content is the topic |
| pyenv layout, nvm, rbenv, asdf use, dotenv, editor | `references/integrations.md` | Integrating direnv with other tools or editors is the topic |

## Quick Start

```bash
# Allow a directory's .envrc
direnv allow

# Check current status
direnv status

# Edit .envrc and reload automatically on save
direnv edit .

# Reload after manual edits
direnv reload
```

## Core Command Tracks

- **Allow .envrc:** `direnv allow` (required after creating or modifying .envrc)
- **Deny .envrc:** `direnv deny`
- **Reload env:** `direnv reload`
- **Edit safely:** `direnv edit .` (allows after saving)
- **Status:** `direnv status`
- **Prune stale:** `direnv prune` (clean up allowed list for missing directories)

## Safety Guardrails

- Never run `direnv allow` on an `.envrc` from an untrusted source without reviewing its contents first.
- Do not commit secrets directly in `.envrc` — load them from a `.env` file excluded by `.gitignore`.
- Add `.envrc` to `.gitignore` if it contains machine-specific paths or credentials; share a `.envrc.example` instead.
- Re-run `direnv allow` whenever `.envrc` is modified — direnv blocks the changed file until re-approved.

## Workflow

1. Install direnv and add the shell hook to the profile (see `references/install-and-setup.md`).
2. Create `.envrc` in the project directory with the required exports or layout.
3. Run `direnv allow` to approve the file.
4. Verify environment variables are set with `direnv status` or `echo $VAR`.
5. When `.envrc` changes, run `direnv allow` again.

## Related Skills

- **nvm** — Node.js version manager, integrates with direnv via `layout node`
- **pyenv** — Python version manager, integrates via `layout pyenv`
- **rbenv** — Ruby version manager, integrates via `layout ruby`
- **asdf** — universal version manager, integrates via `use asdf`

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/envrc-patterns.md`
- `references/integrations.md`
- Official site: <https://direnv.net>
- direnv man page: <https://direnv.net/man/direnv.1.html>
- direnv stdlib: <https://direnv.net/man/direnv-stdlib.1.html>
