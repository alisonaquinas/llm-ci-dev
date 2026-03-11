---
name: bitwarden-cli
description: Access and manage Bitwarden vault items via the bw CLI. Use when tasks mention bitwarden-cli, bw, Bitwarden vault, BW_SESSION, or managing passwords with Bitwarden.
---

# Bitwarden CLI

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install, first-time setup, env vars | `references/install-and-setup.md` | User needs to install bw or configure server/session |
| CLI commands, get/list/create items | `references/command-cookbook.md` | User needs login/unlock/sync/get/list/create/edit/delete commands |
| Session lifecycle, API key auth | `references/auth-and-session.md` | User asks about BW_SESSION, API key auth, or scripted/CI auth |
| Item types, filtering, export | `references/item-operations-and-filtering.md` | User asks about item types, search filters, JSON templates, or bulk export |

## Quick Start

```bash
# 1. Install (npm)
npm install -g @bitwarden/cli

# 2. Log in and unlock — capture the session key
export BW_SESSION=$(bw login --raw)
# Or if already logged in:
export BW_SESSION=$(bw unlock --raw)

# 3. Sync vault
bw sync

# 4. Retrieve a password
bw get password "My App Login"
```

## Core Command Tracks

- **Login/logout:** `bw login`, `bw logout`
- **Unlock and session:** `bw unlock --raw` → export `BW_SESSION`
- **Sync vault:** `bw sync`
- **Get item:** `bw get item <id-or-name>`, `bw get password <id>`, `bw get notes <id>`
- **List items:** `bw list items --search <term>`
- **Create/edit/delete:** `bw create item`, `bw edit item <id>`, `bw delete item <id>`
- **Session flag:** `bw get item <id> --session $BW_SESSION`

## Safety Guardrails

- Never store `BW_SESSION` or master password in plaintext files or version control.
- Session keys expire — regenerate with `bw unlock --raw` for each pipeline run.
- Use API key authentication (`BW_CLIENTID`/`BW_CLIENTSECRET`) for headless CI/CD; store keys as encrypted secrets.
- Prefer `bw get password` over `bw get item` when only the password field is needed to limit data exposure.
- Run `bw lock` after automated operations to clear the session from memory.
- Grant collection access at the minimum scope required for each service account.

## Workflow

1. Install `bw` and run `bw config server <url>` for self-hosted instances.
2. Authenticate with `bw login` (interactive) or API key (headless).
3. Unlock the vault with `bw unlock --raw` and capture the session key.
4. Run `bw sync` to pull the latest vault state.
5. Use `bw get` or `bw list` to retrieve secrets.
6. Run `bw lock` when finished.

```bash
# Headless API key auth pattern for CI (no interactive prompt)
export BW_CLIENTID="user.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export BW_CLIENTSECRET="XXXXXXXXXXXXXXXXXXXXXXXX"
bw login --apikey
export BW_SESSION=$(bw unlock --passwordenv BW_CLIENTSECRET --raw)
bw get password "My CI Token"
```

## Related Skills

- **ci-architecture** — patterns for injecting secrets from Bitwarden into pipeline jobs
- **direnv** — using `.envrc` to populate environment variables from Bitwarden sessions

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/auth-and-session.md`
- `references/item-operations-and-filtering.md`
- Official CLI docs: <https://bitwarden.com/help/cli/>
- Source and issues: <https://github.com/bitwarden/cli>
