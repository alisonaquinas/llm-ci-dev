---
name: aws-secretsmanager
description: Store and retrieve secrets with AWS Secrets Manager. Use when tasks mention aws-secretsmanager, AWS Secrets Manager, get-secret-value, secret rotation, or storing secrets in AWS.
---

# AWS Secrets Manager

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Setup, IAM permissions, env vars | `references/install-and-setup.md` | User needs AWS CLI setup, IAM policies, or KMS key configuration |
| CLI commands, CRUD operations | `references/command-cookbook.md` | User needs create/get/put/update/describe/list/delete/rotate commands |
| Rotation, versions, staging labels | `references/rotation-and-versions.md` | User asks about automatic rotation, Lambda rotation, or version staging labels |
| IAM policies, KMS, VPC, audit | `references/access-control-and-iam.md` | User asks about least-privilege IAM, cross-account access, KMS keys, or CloudTrail |

## Quick Start

```bash
# 1. Create a secret
aws secretsmanager create-secret \
  --name "myapp/prod/db-password" \
  --secret-string "s3cr3t"

# 2. Retrieve a secret value
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-password" \
  --query SecretString --output text

# 3. Update the secret value
aws secretsmanager put-secret-value \
  --secret-id "myapp/prod/db-password" \
  --secret-string "n3wpassword"
```

## Core Command Tracks

- **Create:** `aws secretsmanager create-secret --name <name> --secret-string <value>`
- **Get:** `aws secretsmanager get-secret-value --secret-id <id>`
- **Update:** `aws secretsmanager put-secret-value --secret-id <id> --secret-string <value>`
- **Describe:** `aws secretsmanager describe-secret --secret-id <id>`
- **List:** `aws secretsmanager list-secrets`
- **Delete:** `aws secretsmanager delete-secret --secret-id <id> --recovery-window-in-days 7`
- **Rotate:** `aws secretsmanager rotate-secret --secret-id <id>`

## Safety Guardrails

- Never hardcode secret values in shell scripts, application code, or version control.
- Prefer `--query SecretString` with `--output text` to avoid writing raw JSON (which may include metadata) to logs.
- Use least-privilege IAM policies: grant `secretsmanager:GetSecretValue` only to roles that need it.
- Set a recovery window (`--recovery-window-in-days`) when deleting secrets to allow accidental recovery.
- Use customer-managed KMS keys (CMK) for secrets that require stricter key rotation or cross-account access control.
- Enable CloudTrail logging to audit all `GetSecretValue` calls.
- Avoid `--force-delete-without-recovery` unless the secret is confirmed safe to permanently remove.

## Workflow

1. Ensure the AWS CLI is configured with appropriate credentials and region (`AWS_REGION` or `--region`).
2. Verify IAM permissions include the required `secretsmanager:*` actions.
3. Create secrets with descriptive hierarchical names (e.g., `app/environment/key`).
4. Retrieve secrets at runtime rather than storing them in environment files.
5. Enable automatic rotation for database credentials using built-in Lambda rotation functions.
6. Tag secrets for cost allocation and access control.

```bash
# Create a JSON-structured secret for database credentials
aws secretsmanager create-secret \
  --name "myapp/prod/db-credentials" \
  --secret-string '{"user":"db_user","pass":"s3cr3t"}'

# Retrieve and parse the JSON secret value
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-credentials" \
  --query SecretString --output text | python3 -c "import sys,json; s=json.load(sys.stdin); print(s['user'])"
```

## Related Skills

- **aws** — general AWS CLI setup, credential management, profiles, and cross-service patterns
- **terraform** — managing Secrets Manager secrets declaratively via the AWS Terraform provider
- **ci-architecture** — injecting Secrets Manager values into CI/CD pipeline environments
- **vault** — HashiCorp Vault as an alternative secrets management solution

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/rotation-and-versions.md`
- `references/access-control-and-iam.md`
- CLI reference: <https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/>
- Troubleshooting: <https://docs.aws.amazon.com/secretsmanager/latest/userguide/troubleshoot.html>
