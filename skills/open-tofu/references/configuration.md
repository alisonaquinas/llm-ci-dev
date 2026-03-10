# OpenTofu Configuration

OpenTofu uses the same HCL syntax as Terraform. All configuration patterns (providers, variables, outputs, locals, backends) are identical. The key differences are:

- **Registry source:** Use `registry.opentofu.org` for OpenTofu-specific providers; `registry.terraform.io` providers also work via compatibility layer.
- **State encryption:** OpenTofu adds a native `encryption {}` block (see below).

## Provider Block

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # resolved via registry.opentofu.org
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.6"
}

provider "aws" {
  region = var.aws_region
}
```

## Variables (`variables.tf`)

```hcl
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}
```

## Outputs (`outputs.tf`)

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "secret_value" {
  value     = random_password.db.result
  sensitive = true
}
```

## Backend Configuration

Backend configuration is identical to Terraform. See `terraform` skill `references/configuration.md` for S3, GCS, and HCP Terraform examples.

## State Encryption (OpenTofu-Specific)

OpenTofu supports encrypting state at rest without a remote backend:

```hcl
terraform {
  encryption {
    key_provider "pbkdf2" "my_passphrase" {
      passphrase = var.state_passphrase
    }
    method "aes_gcm" "default_method" {
      keys = key_provider.pbkdf2.my_passphrase
    }
    state {
      method = method.aes_gcm.default_method
    }
    plan {
      method = method.aes_gcm.default_method
    }
  }
}
```

For advanced encryption key providers (AWS KMS, GCP KMS, OpenBao/Vault), see the [OpenTofu encryption docs](https://opentofu.org/docs/language/state/encryption/).

## Provider Registry Differences

- OpenTofu registry: <https://registry.opentofu.org>
- Terraform registry providers work in OpenTofu via automatic redirect.
- A small number of providers may have version-specific behavior differences — check release notes when upgrading.
