# 1Password CLI Install & Setup

## Prerequisites

- macOS, Linux, or Windows
- A 1Password account (personal, team, or business)
- For service account usage: a service account token with vault access

## Install by Platform

### macOS (Homebrew)

```bash
brew install 1password-cli

# Verify
op --version
```

### Linux (manual binary)

```bash
# Download from https://app-updates.agilebits.com/product_history/CLI2
# Example: Linux amd64
curl -sSfLo op.zip \
  "https://cache.agilebits.com/dist/1P/op2/pkg/v2.29.0/op_linux_amd64_v2.29.0.zip"
unzip op.zip
sudo mv op /usr/local/bin/
op --version
```

### Windows (Winget)

```powershell
winget install AgileBits.1Password.CLI

op --version
```

## Account Setup

```bash
# Sign in interactively (first time — sets up local keychain)
op signin

# Sign in to a specific account by sign-in address
op signin --account my.1password.com

# List signed-in accounts
op account list

# Sign out of all accounts
op signout --all
```

## Environment Variables

| Variable | Purpose |
| --- | --- |
| `OP_SERVICE_ACCOUNT_TOKEN` | Service account token for headless/CI auth (no interactive sign-in needed) |
| `OP_ACCOUNT` | Account shorthand to use when multiple accounts are configured |
| `OP_FORMAT` | Default output format (`json`, `csv`, `table`); default is `table` |
| `OP_CONNECT_HOST` | URL of a 1Password Connect server |
| `OP_CONNECT_TOKEN` | Token for authenticating to a 1Password Connect server |

## Service Account Token

For CI/CD pipelines, set `OP_SERVICE_ACCOUNT_TOKEN` to authenticate without interactive prompts:

```bash
export OP_SERVICE_ACCOUNT_TOKEN="ops_eyJ..."

# Verify access
op vault list
op item list
```

## Config File Location

The CLI stores account configuration at:

- **macOS/Linux:** `~/.config/op/config`
- **Windows:** `%APPDATA%\1Password\config`

## Biometric Unlock Integration

On macOS and Windows, the CLI can use the 1Password desktop app for biometric unlock (Touch ID, Windows Hello):

```bash
# Enable biometric unlock (requires 1Password app installed)
op signin --biometric
```

## Post-Install Verification

```bash
op --version

# With service account token
export OP_SERVICE_ACCOUNT_TOKEN="ops_eyJ..."
op vault list
op item list --vault "Private"
op read "op://Private/My App/password"
```
