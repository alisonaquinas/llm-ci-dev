---
name: open-tofu
description: Plan, apply, and manage infrastructure with OpenTofu (community fork of Terraform). Use when tasks mention tofu commands, OpenTofu configuration, migration from Terraform, or the open-source Terraform alternative.
---

# OpenTofu

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup, tofuenv | `references/install-and-setup.md` | User needs to install OpenTofu or manage versions |
| Provider config, variables, backends | `references/configuration.md` | User needs provider blocks, variable files, or backend setup |
| CLI commands, workflows | `references/command-cookbook.md` | User needs init/plan/apply/destroy patterns or tofu-specific commands |
| Migrate from Terraform | `references/migrating-from-terraform.md` | User wants to switch from Terraform to OpenTofu |

## Quick Start

```bash
# 1. Initialize working directory (downloads providers)
tofu init

# 2. Preview changes (always run before apply)
tofu plan

# 3. Apply changes (requires confirmation)
tofu apply

# 4. Destroy infrastructure (DANGEROUS — requires confirmation)
tofu destroy
```

## Key Differences from Terraform

| Feature | OpenTofu | Terraform |
| --- | --- | --- |
| Binary | `tofu` | `terraform` |
| License | MPL 2.0 (open source) | BSL 1.1 (source-available) |
| Registry | registry.opentofu.org | registry.terraform.io |
| Native testing | `tofu test` (built-in) | `terraform test` (1.6+) |
| Encryption at rest | Built-in state encryption | Not available |
| State compatibility | Compatible with TF state | — |

## Core Command Tracks

- **Initialize:** `tofu init` — downloads providers, sets up backend
- **Validate & format:** `tofu validate`, `tofu fmt -recursive`
- **Preview:** `tofu plan [-out=tofuplan]` — no changes made
- **Apply:** `tofu apply [tofuplan]` — creates/updates resources
- **Test:** `tofu test` — run native HCL tests
- **Inspect state:** `tofu state list`, `tofu state show <resource>`
- **Workspaces:** `tofu workspace list`, `tofu workspace select <name>`

## Safety Guardrails

- Always run `tofu plan` before `tofu apply` — review the diff carefully.
- `tofu destroy` is **irreversible** — confirm resource list before proceeding.
- Never commit `terraform.tfstate` or `.tfvars` files containing secrets to version control.
- Enable state locking on remote backends to prevent concurrent modifications.
- OpenTofu's built-in state encryption adds an extra layer of protection.

```bash
# Inspect managed resources in state before making changes
tofu state list
tofu state show aws_instance.web
```

## Workflow

1. Write or edit `.tf` configuration files (HCL is identical to Terraform).
2. Run `tofu fmt` to normalize formatting.
3. Run `tofu validate` to catch syntax errors.
4. Run `tofu plan` and review the proposed changes.
5. Run `tofu apply` only after reviewing the plan.
6. Commit `.terraform.lock.hcl` (or `.opentofu.lock.hcl`) but never state files.

## Related Skills

- **terraform** — HashiCorp's IaC tool; OpenTofu is a compatible fork
- **pulumi** — IaC using general-purpose languages (TypeScript, Python, Go, C#)
- **ansible** — configuration management and agentless automation
- **ci-architecture** — integrating OpenTofu into CI/CD pipelines
- **aws** — AWS CLI for inspecting resources managed by OpenTofu

## References

- `references/install-and-setup.md`
- `references/configuration.md`
- `references/command-cookbook.md`
- `references/migrating-from-terraform.md`
- Official docs: <https://opentofu.org/docs>
- Provider registry: <https://registry.opentofu.org>
- Migration guide: <https://opentofu.org/docs/intro/migration/>
- Community blog: <https://opentofu.org/blog>
