# Vault Install & Setup

## Prerequisites

- macOS, Linux, or Windows
- 64-bit OS (arm64 or amd64)
- Network access to a Vault server (or local dev mode)

## Install by Platform

### macOS (Homebrew)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/vault

# Verify
vault version
```

### Linux (apt — Ubuntu/Debian)

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault
```

### Linux (manual binary)

```bash
# Check https://releases.hashicorp.com/vault/ for the latest version
VAULT_VERSION=1.17.2
curl -Lo vault.zip "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"
unzip vault.zip
sudo mv vault /usr/local/bin/
vault version
```

### Windows

```powershell
# Chocolatey
choco install vault

# Winget
winget install Hashicorp.Vault
```

## Local Dev Server

```bash
# Start an in-memory dev server (never use in production)
vault server -dev

# The startup output shows:
#   Unseal Key: <key>
#   Root Token: <token>
#   VAULT_ADDR=http://127.0.0.1:8200

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='<root-token-shown-at-startup>'
vault status
```

## Environment Variables

| Variable | Purpose |
| --- | --- |
| `VAULT_ADDR` | Vault server URL (e.g., `https://vault.example.com:8200`) |
| `VAULT_TOKEN` | Auth token used for all requests |
| `VAULT_NAMESPACE` | Enterprise namespace prefix (e.g., `admin/team-a`) |
| `VAULT_SKIP_VERIFY` | Set to `true` to skip TLS verification (dev/test only) |
| `VAULT_CACERT` | Path to a CA certificate file for TLS verification |

## Token File

Vault CLI writes the active token to `~/.vault-token` after `vault login`. This file is read automatically when `VAULT_TOKEN` is not set.

```bash
# View the stored token
cat ~/.vault-token

# Clear it on logout
vault token revoke -self
rm ~/.vault-token
```

## HCL Server Config Overview

For non-dev deployments, Vault reads an HCL config file:

```hcl
storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault.d/vault.crt"
  tls_key_file  = "/etc/vault.d/vault.key"
}

api_addr = "https://vault.example.com:8200"
cluster_addr = "https://vault.example.com:8201"
ui = true
```

```bash
vault server -config=/etc/vault.d/vault.hcl
```

## Post-Install Verification

```bash
vault status
# Expected output includes: Initialized, Sealed status, Cluster Name

vault kv put secret/test hello=world
vault kv get secret/test
vault kv delete secret/test
```
