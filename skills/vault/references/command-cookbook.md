# Vault Command Cookbook

## Authentication

```bash
# Login with a token (prompts for token)
vault login

# Login non-interactively (token from env or stdin)
vault login $VAULT_TOKEN

# Login using AppRole
vault write auth/approle/login \
  role_id="<role-id>" \
  secret_id="<secret-id>"

# Check current token
vault token lookup
```

## KV Secrets Engine (KV v2)

```bash
# Write a secret
vault kv put secret/myapp password=s3cr3t api_key=abc123

# Write from a JSON file
vault kv put secret/myapp @secret.json

# Read a secret (all fields)
vault kv get secret/myapp

# Read a specific field only
vault kv get -field=password secret/myapp

# Read in JSON format
vault kv get -format=json secret/myapp

# List secrets at a path
vault kv list secret/

# Update one field without overwriting others (KV v2 patch)
vault kv patch secret/myapp api_key=newvalue

# Delete the latest version
vault kv delete secret/myapp

# Delete specific versions
vault kv delete -versions=1,2 secret/myapp

# Undelete (restore) a version
vault kv undelete -versions=1 secret/myapp

# Destroy (permanent) specific versions
vault kv destroy -versions=1 secret/myapp

# View version metadata
vault kv metadata get secret/myapp
```

## Generic Read/Write (Non-KV Paths)

```bash
# Read from any path (e.g., dynamic credentials)
vault read database/creds/my-role

# Write to any path
vault write auth/approle/login role_id="..." secret_id="..."

# Delete a path
vault delete secret/myapp
```

## Token Management

```bash
# Look up the current token
vault token lookup

# Look up a specific token
vault token lookup <token>

# Renew the current token
vault token renew

# Renew by a specific increment
vault token renew -increment=1h

# Revoke the current token (self)
vault token revoke -self

# Revoke a specific token
vault token revoke <token>

# Create a child token with a TTL
vault token create -ttl=1h -policy=read-only
```

## Listing Auth Methods and Secrets Engines

```bash
# List enabled auth methods
vault auth list

# List enabled secrets engines
vault secrets list
```

## Lease Management

```bash
# List leases at a path prefix
vault list sys/leases/lookup/database/creds/

# Renew a lease
vault lease renew <lease-id>

# Revoke a lease
vault lease revoke <lease-id>

# Revoke all leases with a prefix
vault lease revoke -prefix database/creds/my-role/
```

## Output Formatting

```bash
# JSON output (scriptable)
vault kv get -format=json secret/myapp | jq '.data.data.password'

# YAML output
vault kv get -format=yaml secret/myapp

# Table output (default)
vault kv get secret/myapp
```

## Status and Diagnostics

```bash
# Check server status (seal state, version, HA)
vault status

# Check operator health
vault operator raft list-peers   # HA Raft clusters

# Audit log (requires audit device enabled)
vault audit list
```
