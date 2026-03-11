# Vault Policies and Leases

## HCL Policy Syntax

Vault policies are written in HCL and grant capabilities on paths.

```hcl
# Allow reading all secrets under secret/myapp/
path "secret/data/myapp/*" {
  capabilities = ["read", "list"]
}

# Allow reading and writing a specific path
path "secret/data/myapp/config" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Deny access to admin paths (explicit deny overrides other rules)
path "secret/data/admin/*" {
  capabilities = ["deny"]
}
```

Available capabilities: `create`, `read`, `update`, `delete`, `list`, `sudo`, `deny`.

Note: KV v2 stores data at `secret/data/<path>` and metadata at `secret/metadata/<path>`. Policies must reference `secret/data/` (not `secret/`) for KV v2 reads.

## Policy Management Commands

```bash
# Write a policy from a file
vault policy write app-read policy.hcl

# Write a policy inline (heredoc)
vault policy write ci-read - <<'EOF'
path "secret/data/ci/*" {
  capabilities = ["read"]
}
EOF

# Read a policy
vault policy read app-read

# List all policies
vault policy list

# Delete a policy
vault policy delete app-read
```

## Lease TTL

Dynamic secrets (database credentials, cloud credentials) are issued with a lease that expires automatically.

```bash
# Read a dynamic credential (returns a lease_id)
vault read database/creds/my-role

# Renew a lease (extend its TTL)
vault lease renew <lease-id>

# Renew with a specific increment
vault lease renew -increment=1h <lease-id>

# Revoke a lease immediately (force credential expiry)
vault lease revoke <lease-id>

# Revoke all leases for a role
vault lease revoke -prefix database/creds/my-role/

# List active leases
vault list sys/leases/lookup/database/creds/my-role/
```

## Dynamic Secrets Concept

Dynamic secrets are generated on-demand and exist only for the duration of their lease. When the lease expires or is revoked, Vault deletes the credential from the target system.

Common dynamic secrets engines:
- **database** — PostgreSQL, MySQL, Oracle short-lived credentials
- **aws** — temporary IAM access keys
- **azure** — Azure service principal credentials
- **pki** — X.509 certificates

For details on enabling dynamic secrets engines, see: <https://developer.hashicorp.com/vault/docs/commands>

## KV v1 vs KV v2

| Feature | KV v1 | KV v2 |
| --- | --- | --- |
| Versioning | No | Yes (default: 10 versions) |
| Path prefix | `secret/<path>` | `secret/data/<path>` |
| Metadata | No | `secret/metadata/<path>` |
| Soft delete | No | Yes (recoverable) |
| Hard destroy | No | Yes (permanent) |

```bash
# Check which version is mounted
vault secrets list -detailed | grep secret

# Enable KV v2 at a new path
vault secrets enable -path=kv2 -version=2 kv

# Upgrade existing KV v1 to v2 (irreversible)
vault kv enable-versioning secret/
```

## Namespace Isolation (Vault Enterprise)

```bash
# Set the namespace for all subsequent commands
export VAULT_NAMESPACE="admin/team-a"

# Or pass per-command
vault kv get -namespace="admin/team-a" secret/myapp

# Create a namespace (requires root or admin policy)
vault namespace create team-b

# List namespaces
vault namespace list
```

For advanced policy and lease configuration, see: <https://developer.hashicorp.com/vault/tutorials>
