---
name: 1password-cli
description: Access 1Password secrets and run commands via op CLI. Use when tasks mention 1password-cli, op, 1Password, secret references (op://), op run, or service account tokens.
---

# 1Password CLI

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install, first-time setup, env vars | `references/install-and-setup.md` | User needs to install op or configure service account tokens |
| CLI commands, item operations | `references/command-cookbook.md` | User needs signin/item get/list/create/edit/delete/read/run commands |
| Secret references, op run, inject | `references/secret-references-and-op-run.md` | User asks about op:// syntax, op run, op inject, or .env file injection |
| Service accounts, Connect server | `references/service-accounts-and-connect.md` | User asks about OP_SERVICE_ACCOUNT_TOKEN, Connect server, or machine auth |

## Quick Start

```bash
# 1. Install (macOS)
brew install 1password-cli

# 2. Sign in
op signin

# 3. List vaults
op vault list

# 4. Retrieve a secret field
op item get "My App" --vault "Private" --fields password

# 5. Inject secrets into a command via secret references
op run -- env
```

## Core Command Tracks

- **Sign in:** `op signin`, `op account list`
- **Read a field:** `op read "op://vault/item/field"`
- **Get item:** `op item get <name> --vault <vault> --format json`
- **List items:** `op item list --vault <vault>`
- **Create/edit/delete:** `op item create`, `op item edit`, `op item delete`
- **Inject and run:** `op run -- <command>`, `op inject -i template.env`
- **Documents:** `op document get <name>`

## Safety Guardrails

- Never commit `OP_SERVICE_ACCOUNT_TOKEN` or session tokens to version control; use encrypted CI/CD secret storage.
- Scope service accounts to the minimum set of vaults required.
- Prefer `op run` or `op inject` over extracting secrets into shell variables that may appear in logs.
- Rotate service account tokens regularly and revoke tokens for decommissioned pipelines.
- Use secret references (`op://vault/item/field`) in config files instead of hardcoded values.
- Avoid logging the output of `op read` or `op item get` in CI pipelines.

## Workflow

1. Install `op` and authenticate with `op signin` or set `OP_SERVICE_ACCOUNT_TOKEN`.
2. Verify access with `op vault list` and `op item list`.
3. Use `op read "op://vault/item/field"` to retrieve individual field values.
4. Use `op run -- <command>` to inject secrets as environment variables for a single command.
5. Use `op inject -i .env.tpl -o .env` for file-based secret injection.
6. In CI/CD, set `OP_SERVICE_ACCOUNT_TOKEN` as an encrypted secret and use `op run` in pipeline steps.

## Related Skills

- **aws** — AWS CLI; combine with 1Password to retrieve AWS credentials at runtime
- **ci-architecture** — patterns for secret injection using op run in GitHub Actions or GitLab CI
- **direnv** — using `.envrc` with `op run` for local development secret loading
- **aws-secretsmanager** — AWS-native alternative for secrets stored in AWS environments

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/secret-references-and-op-run.md`
- `references/service-accounts-and-connect.md`
- CLI reference: <https://developer.1password.com/docs/cli/reference/>
- Service accounts: <https://developer.1password.com/docs/service-accounts/>
