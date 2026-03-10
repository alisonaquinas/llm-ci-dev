---
name: aws
description: Operate AWS CLI (`aws`) for authentication checks, profile and region context inspection, service command planning, and safe command execution. Use when tasks mention AWS CLI commands, profiles/regions, STS identity checks, or AWS service operations from terminal workflows.
---

# AWS CLI

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup | `references/install-and-setup.md` | User needs to install AWS CLI or do initial configuration |
| Command patterns, JMESPath | `references/command-cookbook.md` | User needs S3/EC2/IAM/Lambda patterns, query syntax, or command examples |
| Authentication, credentials, SSO | `references/auth-and-config.md` | User needs credential chain info, SSO setup, MFA, or troubleshooting auth errors |

## Workflow

1. Run preflight before AWS CLI workflows.
2. Check authentication and identity (`sts get-caller-identity`).
3. Confirm active profile and region context.
4. Choose a service command track and inspect first.
5. Require explicit confirmation before mutating commands.

## Preflight

Use bundled scripts:

- `scripts/aws-preflight.sh`
- `scripts/aws-auth-status.sh`
- `scripts/aws-context.sh`
- `scripts/aws-diagnostics.sh [--json] [--out <file>]`

## Core Command Tracks

- Identity and context:
`aws sts get-caller-identity`, `aws configure list-profiles`, `aws configure get region`
- Service inspection:
`aws <service> list-*`, `aws <service> describe-*`, `aws <service> get-*`
- Output and filtering:
Use `--query` (JMESPath) and `--output json|table|yaml`.
- Profile and region targeting:
Use `--profile` and `--region` explicitly for multi-account workflows.

## Safety Guardrails

- Inspect commands first, then propose mutations.
- Ask for explicit confirmation before `create`, `put`, `update`, `delete`, `terminate`, or policy changes.
- Avoid exposing credential values or sensitive account details.
- Use the narrowest scope possible (resource ARN/ID, profile, and region).

## Troubleshooting

- If identity checks fail, verify credentials/profile and re-run `scripts/aws-auth-status.sh`.
- If region is missing, set `AWS_REGION` or configure region for the active profile.
- If endpoint/network calls fail, capture diagnostics first and retry when connectivity is available.

## References

- `references/command-cookbook.md`
- AWS CLI v2 command reference: <https://docs.aws.amazon.com/cli/latest/reference/>
