# Migrating from Terraform to OpenTofu

## Overview

OpenTofu is a drop-in replacement for Terraform. The state file format is compatible, and all HCL configuration files work without changes for the vast majority of use cases.

## Migration Steps

### 1. Install OpenTofu

See `references/install-and-setup.md` for installation instructions. You can install OpenTofu alongside Terraform — they use separate binaries (`tofu` vs `terraform`).

### 2. Verify Configuration Compatibility

```bash
# Copy your existing Terraform project directory (optional safety step)
cp -r my-tf-project/ my-tofu-project/
cd my-tofu-project/

# Initialize with OpenTofu (reads existing .tf files and state)
tofu init
```

OpenTofu will download providers from `registry.opentofu.org` (which mirrors `registry.terraform.io`).

### 3. Run Plan to Verify No Changes

```bash
tofu plan
```

If the plan shows no changes, your state and configuration are compatible. If changes appear, investigate provider version differences.

### 4. Update Provider Sources (Optional)

For providers with dedicated OpenTofu registry entries, update the source:

```hcl
# Before (Terraform)
source = "hashicorp/aws"

# After (OpenTofu — functionally identical, uses OpenTofu registry)
source = "hashicorp/aws"   # same — registry.opentofu.org mirrors hashicorp namespace
```

Most users do not need to change provider sources.

### 5. Update CI/CD Pipelines

Replace `terraform` binary calls with `tofu`:

```yaml
# Before
- run: terraform init && terraform plan

# After
- run: tofu init && tofu plan
```

Update any setup actions (e.g., `hashicorp/setup-terraform@v3` → `opentofu/setup-opentofu@v1`).

## License Considerations

| | Terraform (≥ 1.6) | OpenTofu |
| --- | --- | --- |
| License | BSL 1.1 (source-available) | MPL 2.0 (open source) |
| Commercial use | Restricted by BSL | Unrestricted |
| Forks/redistribution | Restricted by BSL | Permitted under MPL |

OpenTofu was forked before Terraform 1.6 (the BSL change), based on Terraform 1.5.x source under MPL 2.0.

## State File Compatibility

- State files are fully compatible between Terraform and OpenTofu at the same major version.
- You can switch back and forth between `tofu` and `terraform` on the same state file.
- **Caution:** After using OpenTofu state encryption, state files cannot be read by standard Terraform without decryption.

## Known Differences

| Area | Notes |
| --- | --- |
| `tofu test` | Native testing available in all versions; Terraform added `terraform test` in 1.6 |
| State encryption | OpenTofu-only feature |
| Provider registry | OpenTofu registry mirrors Terraform registry; a few providers may differ |
| `tofu providers lock` | Slightly different flags; behavior equivalent |

## Rollback

To revert to Terraform:

```bash
cd my-project/
terraform init   # re-initializes with Terraform; state is compatible
terraform plan   # verify no unexpected changes
```

For advanced migration scenarios (Terraform Enterprise, Sentinel policies, module registry), see the [OpenTofu migration guide](https://opentofu.org/docs/intro/migration/).
