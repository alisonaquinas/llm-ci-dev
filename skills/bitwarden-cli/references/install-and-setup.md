# Bitwarden CLI Install & Setup

## Prerequisites

- Node.js 18+ (for npm install) — or use a standalone binary
- A Bitwarden account (cloud or self-hosted server)

## Install by Method

### npm (cross-platform)

```bash
npm install -g @bitwarden/cli

# Verify
bw --version
```

### Homebrew (macOS/Linux)

```bash
brew install bitwarden-cli

bw --version
```

### Standalone Binary

Download the latest binary for your platform from the official releases page and place it in your `$PATH`:

- macOS, Linux, Windows binaries available at: <https://bitwarden.com/help/cli/>

```bash
# Example: Linux x64
chmod +x bw
sudo mv bw /usr/local/bin/
bw --version
```

## Initial Configuration

```bash
# For self-hosted Bitwarden servers, point the CLI at your instance
bw config server https://vault.example.com

# Verify the configured server
bw config server
```

## Environment Variables

| Variable | Purpose |
| --- | --- |
| `BW_SESSION` | Session key returned by `bw unlock --raw`; passed to commands with `--session` |
| `BW_CLIENTID` | API key client ID for headless login (format: `user.<uuid>`) |
| `BW_CLIENTSECRET` | API key client secret for headless login |
| `BW_SERVER` | Bitwarden server URL (alternative to `bw config server`) |
| `BITWARDENCLI_APPDATA_DIR` | Override the directory where the CLI stores its config and data |

## Login Methods Overview

| Method | Use Case | Command |
| --- | --- | --- |
| Email + master password | Interactive sessions | `bw login` |
| Email + master password + 2FA | Interactive with MFA | `bw login` (prompts for 2FA) |
| API key | Headless/CI — no MFA required | `bw login --apikey` |
| SSO | Enterprise accounts with SSO | `bw login --sso` |

## Post-Install Verification

```bash
bw --version

# Log in interactively
bw login

# Unlock and capture session key
export BW_SESSION=$(bw unlock --raw)

# Sync vault
bw sync

# Test retrieval
bw list items | head -20
```
