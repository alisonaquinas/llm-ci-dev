# OpenTofu Command Cookbook

All `tofu` subcommands mirror Terraform subcommands. Replace `terraform` with `tofu` in any Terraform workflow. Additional OpenTofu-specific commands are noted below.

## Initialization

```bash
tofu init
tofu init -upgrade
tofu init -reconfigure -backend-config="bucket=new-bucket"
```

## Validation & Formatting

```bash
tofu validate
tofu fmt -recursive
tofu fmt -check -recursive   # CI-safe check
```

## Planning

```bash
tofu plan
tofu plan -out=tofuplan
tofu plan -target=aws_instance.web
tofu plan -destroy
```

## Applying

```bash
tofu apply
tofu apply tofuplan
tofu apply -auto-approve    # CI/CD — use with care
tofu apply -refresh-only
```

## Destroying

> **DANGER:** `tofu destroy` removes all managed resources. Always run `tofu plan -destroy` first.

```bash
tofu plan -destroy
tofu destroy
tofu destroy -target=aws_instance.web
```

## State Commands

```bash
tofu state list
tofu state show aws_s3_bucket.data
tofu state mv aws_instance.old aws_instance.new
tofu state rm aws_instance.web
tofu state pull
tofu state push terraform.tfstate
```

## Native Testing (`tofu test`)

OpenTofu includes a built-in test framework using `.tftest.hcl` files:

```hcl
# tests/basic.tftest.hcl
run "creates_bucket" {
  command = apply

  assert {
    condition     = aws_s3_bucket.data.bucket == "my-bucket"
    error_message = "Bucket name mismatch"
  }
}
```

```bash
# Run all tests
tofu test

# Run a specific test file
tofu test -filter=tests/basic.tftest.hcl

# Run in verbose mode
tofu test -verbose
```

## Provider Lock

```bash
# Regenerate provider lock file for all platforms
tofu providers lock \
  -platform=linux_amd64 \
  -platform=darwin_arm64 \
  -platform=windows_amd64

# Show provider requirements
tofu providers
```

## Workspaces

```bash
tofu workspace list
tofu workspace new staging
tofu workspace select prod
tofu workspace show
tofu workspace delete staging
```

## Output

```bash
tofu output
tofu output instance_id
tofu output -json
```

## Import

```bash
tofu import aws_instance.web i-0123456789abcdef
```

For advanced OpenTofu features (module testing, encryption key rotation, OPA policy integration), see <https://opentofu.org/docs>.
