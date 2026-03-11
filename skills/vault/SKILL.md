---
name: vault
description: Manage secrets, tokens, and policies with HashiCorp Vault. Use when tasks mention vault commands, HashiCorp Vault, KV secrets engine, Vault tokens, VAULT_ADDR, VAULT_TOKEN, or Vault policies.
---

# HashiCorp Vault

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install, first-time setup, env vars | `references/install-and-setup.md` | User needs to install Vault or configure VAULT_ADDR/VAULT_TOKEN |
| CLI commands, KV operations | `references/command-cookbook.md` | User needs login/kv get/put/read/write/token/lease commands |
| Auth methods, AppRole, Kubernetes | `references/auth-methods.md` | User asks about AppRole, AWS IAM auth, Kubernetes auth, or token workflows |
| Policies, leases, KV versions | `references/policies-and-leases.md` | User asks about HCL policies, TTLs, dynamic secrets, or KV v1 vs v2 |

## Quick Start

```bash
# 1. Start a dev server (local testing only)
vault server -dev

# 2. Export connection details (shown by dev server startup)
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='<root-token-shown-at-startup>'

# 3. Verify connectivity
vault status

# 4. Write and read a secret
vault kv put secret/myapp password=s3cr3t
vault kv get secret/myapp
```

## Core Command Tracks

- **Login:** `vault login` — authenticate with a token or auth method
- **KV secrets:** `vault kv get/put/list/delete <path>` — KV v2 operations
- **Generic path:** `vault read/write <path>` — read or write arbitrary Vault paths
- **Token management:** `vault token lookup`, `vault token renew`, `vault token revoke`
- **List auth methods:** `vault auth list`
- **List secrets engines:** `vault secrets list`
- **Lease operations:** `vault lease renew <lease-id>`, `vault lease revoke <lease-id>`

## Safety Guardrails

- Never commit `VAULT_TOKEN` or any root/admin token to version control.
- Use short-lived tokens with minimal capabilities — prefer AppRole or Kubernetes auth for CI/CD.
- Prefer environment variables (`VAULT_ADDR`, `VAULT_TOKEN`) over hardcoded values in scripts.
- Grant least-privilege: scope policies to the exact paths and capabilities needed.
- Dev server (`vault server -dev`) stores data in memory only — do not use it for production.
- Rotate root tokens immediately after initial setup and use operator-level tokens sparingly.

## Workflow

1. Authenticate with `vault login` or set `VAULT_TOKEN` in the environment.
2. Verify connectivity with `vault status`.
3. Use `vault kv put` to store secrets and `vault kv get` to retrieve them.
4. Apply least-privilege policies with `vault policy write`.
5. Use AppRole or Kubernetes auth for automated pipelines instead of static tokens.
6. Monitor lease TTLs and renew or revoke as appropriate.

```bash
# Troubleshoot an expired token: look up current token info and renew if possible
vault token lookup
vault token renew
vault status
```

## Related Skills

- **aws** — AWS CLI; also covers AWS IAM auth used with Vault's AWS auth method
- **terraform** — Terraform Vault provider for managing Vault resources declaratively
- **ansible** — Ansible lookup plugin for reading Vault secrets in playbooks
- **ci-architecture** — injecting Vault secrets into CI/CD pipeline environments

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/auth-methods.md`
- `references/policies-and-leases.md`
- CLI reference: <https://developer.hashicorp.com/vault/docs/commands>
- Tutorials: <https://developer.hashicorp.com/vault/tutorials>
