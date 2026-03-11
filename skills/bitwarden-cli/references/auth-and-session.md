# Bitwarden CLI Auth and Session Management

## API Key Authentication (Headless/CI)

API key authentication avoids interactive prompts and does not require two-factor authentication. This is the recommended method for CI/CD pipelines.

```bash
# Set credentials as environment variables
export BW_CLIENTID="user.<uuid>"
export BW_CLIENTSECRET="<client-secret>"

# Log in using API key (reads from env vars automatically)
bw login --apikey

# Then unlock to get the session key (requires BW_PASSWORD or interactive prompt)
export BW_SESSION=$(bw unlock --raw)
```

Store `BW_CLIENTID` and `BW_CLIENTSECRET` as encrypted CI/CD secrets, never in plaintext files.

## Session Key Lifecycle

1. **Login** (`bw login`) — authenticates and creates a local encrypted vault copy.
2. **Unlock** (`bw unlock`) — decrypts the local vault using the master password; returns a session key.
3. **BW_SESSION** — the session key authorizes all subsequent `bw` commands.
4. **Lock** (`bw lock`) — revokes the session key and re-encrypts the in-memory vault.

```bash
# Full headless workflow for CI
export BW_CLIENTID="user.<uuid>"
export BW_CLIENTSECRET="<secret>"
export BW_PASSWORD="<master-password>"   # store as encrypted secret

bw login --apikey
export BW_SESSION=$(bw unlock --raw)
bw sync

# ... use bw get / bw list commands ...

bw lock
```

## Using --session Flag

Pass the session key explicitly instead of relying on the `BW_SESSION` environment variable:

```bash
SESSION=$(bw unlock --raw)
bw get password "My App" --session "$SESSION"
bw list items --session "$SESSION"
```

## Device Trust and Approval

On new devices, Bitwarden may require device approval before allowing login. For CI environments, pre-approve devices or use API key authentication to bypass device trust checks.

## Organization and SSO Login

```bash
# Log in to an organization with SSO
bw login --sso

# List organizations accessible to the account
bw list organizations

# List collections in an organization
bw list collections --organizationid "<org-uuid>"
```

## Self-Hosted Server Configuration

```bash
# Point CLI at a self-hosted server
bw config server https://vault.example.com

# Verify
bw config server

# Reset to Bitwarden cloud
bw config server https://vault.bitwarden.com
```

## Scripted Auth Pattern for CI/CD

```bash
#!/bin/bash
set -euo pipefail

# Credentials from CI/CD encrypted secrets
export BW_CLIENTID="${BW_CLIENTID}"
export BW_CLIENTSECRET="${BW_CLIENTSECRET}"
export BW_PASSWORD="${BW_PASSWORD}"

bw login --apikey --quiet
BW_SESSION=$(bw unlock --raw)
export BW_SESSION

bw sync --quiet

DB_PASSWORD=$(bw get password "production-db" --session "$BW_SESSION")
export DB_PASSWORD

bw lock --quiet
```

For advanced patterns, see: <https://bitwarden.com/help/cli/>
