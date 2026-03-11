# 1Password Service Accounts and Connect

## Service Accounts

Service accounts enable headless, non-interactive authentication for CI/CD pipelines and automation scripts. They do not require a human user session or biometric authentication.

### Creating a Service Account

Service accounts are created in the 1Password web interface:

1. Sign in to 1Password at <https://my.1password.com>
2. Go to **Developer Tools** → **Service Accounts**
3. Click **New Service Account**, name it, and select vault access
4. Copy the token immediately — it is shown only once

### Using the Token

```bash
# Set token in the environment
export OP_SERVICE_ACCOUNT_TOKEN="ops_eyJ..."

# Verify access
op vault list
op item list
```

### Token Lifecycle

```bash
# Service account tokens do not expire by default but can be revoked
# from the 1Password web interface under Developer Tools → Service Accounts

# In CI/CD: store the token as an encrypted secret
# GitHub Actions: use a repository/org secret named OP_SERVICE_ACCOUNT_TOKEN
# GitLab CI: use a masked CI/CD variable
```

### Scoping Vault Permissions

When creating a service account, grant access only to the vaults the pipeline requires:

- Read-only access is sufficient for most pipelines
- Separate service accounts per environment (dev, staging, production) are recommended
- Revoke tokens for decommissioned services immediately

## Rotating Service Account Tokens

There is no built-in CLI command to rotate tokens. Rotation must be performed via the web interface:

1. Create a new service account token in the web interface
2. Update the encrypted CI/CD secret with the new token
3. Revoke the old token from the web interface

## 1Password Connect Server

1Password Connect provides a self-hosted REST API for accessing secrets without the 1Password cloud service. It is suited for air-gapped or on-premises environments.

### Architecture

- **Connect Server** — a Docker container running the Connect API
- **Connect Token** — authorizes requests to the Connect API
- **Sync** — the Connect server syncs vaults from 1Password cloud on a schedule

### Environment Variables for Connect

| Variable | Purpose |
| --- | --- |
| `OP_CONNECT_HOST` | URL of the Connect server (e.g., `https://connect.example.com`) |
| `OP_CONNECT_TOKEN` | Token for authenticating to the Connect API |

```bash
export OP_CONNECT_HOST="https://connect.example.com"
export OP_CONNECT_TOKEN="<connect-token>"

# Read a secret through Connect
op read "op://vault-uuid/item-uuid/password"

# List vaults via Connect
op vault list
```

### SDK and API Access vs CLI Access

| Access Method | Use Case |
| --- | --- |
| `op` CLI | Shell scripts, CI/CD pipelines, local development |
| Connect REST API | Application code needing secrets at runtime |
| 1Password SDKs | Native language integration (Go, Python, Node.js, Java) |

```bash
# Connect REST API example (direct HTTP)
curl -s -H "Authorization: Bearer $OP_CONNECT_TOKEN" \
  "$OP_CONNECT_HOST/v1/vaults" | jq '.[] | .name'
```

## Machine-to-Machine Auth Patterns

### Pattern 1: Service Account in CI Pipeline

```bash
# Set once in CI/CD encrypted secrets:
#   OP_SERVICE_ACCOUNT_TOKEN = ops_eyJ...

export OP_SERVICE_ACCOUNT_TOKEN="$OP_SERVICE_ACCOUNT_TOKEN"

DB_PASSWORD=$(op read "op://Production/AppDB/password")
op run --env-file .env.prod -- ./deploy.sh
```

### Pattern 2: Connect Server in Kubernetes

```yaml
# Kubernetes deployment with Connect token as a Secret
env:
  - name: OP_CONNECT_HOST
    value: "http://op-connect.infra.svc.cluster.local:8080"
  - name: OP_CONNECT_TOKEN
    valueFrom:
      secretKeyRef:
        name: op-connect-token
        key: token
```

For advanced service account and Connect server configuration, see: <https://developer.1password.com/docs/service-accounts/>
