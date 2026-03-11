# AWS Secrets Manager Install & Setup

## Prerequisites

- AWS CLI v2 installed and configured (see the `aws` skill for full installation details)
- An AWS account with appropriate IAM permissions for Secrets Manager
- `AWS_REGION` set or `--region` flag used in all commands

## AWS CLI Installation (Summary)

For full AWS CLI installation instructions, refer to the `aws` skill. Quick reference:

```bash
# macOS
brew install awscli

# Linux (official installer)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip && sudo ./aws/install

# Verify
aws --version
```

## Credential Configuration

```bash
# Configure credentials interactively
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID="<key-id>"
export AWS_SECRET_ACCESS_KEY="<secret-key>"
export AWS_REGION="us-east-1"

# Verify
aws sts get-caller-identity
```

## Environment Variables

| Variable | Purpose |
| --- | --- |
| `AWS_REGION` | Default AWS region for Secrets Manager operations |
| `AWS_PROFILE` | Named profile from `~/.aws/credentials` and `~/.aws/config` |
| `AWS_ACCESS_KEY_ID` | Access key for programmatic access |
| `AWS_SECRET_ACCESS_KEY` | Secret key for programmatic access |
| `AWS_SESSION_TOKEN` | Session token for temporary credentials (STS/OIDC) |

## IAM Permissions Required

Grant only the permissions each role actually needs. Common permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "arn:aws:secretsmanager:us-east-1:123456789012:secret:myapp/*"
    }
  ]
}
```

Full set of Secrets Manager actions: `CreateSecret`, `GetSecretValue`, `PutSecretValue`, `UpdateSecret`, `DescribeSecret`, `ListSecrets`, `DeleteSecret`, `RotateSecret`, `TagResource`, `UntagResource`, `GetResourcePolicy`, `PutResourcePolicy`, `ReplicateSecretToRegions`.

## KMS Key Setup for Custom Encryption

By default, secrets are encrypted with the AWS-managed key (`aws/secretsmanager`). To use a customer-managed KMS key (CMK):

```bash
# Create a KMS key
aws kms create-key --description "Secrets Manager CMK"

# Note the KeyId from the output, then create a secret with it
aws secretsmanager create-secret \
  --name "myapp/prod/key" \
  --kms-key-id "<key-id-or-alias>" \
  --secret-string "value"
```

## VPC Endpoint Setup Overview

To access Secrets Manager from within a VPC without internet access, create a VPC endpoint:

```bash
aws ec2 create-vpc-endpoint \
  --vpc-id "<vpc-id>" \
  --service-name "com.amazonaws.us-east-1.secretsmanager" \
  --vpc-endpoint-type Interface \
  --subnet-ids "<subnet-id>" \
  --security-group-ids "<sg-id>"
```

For complete VPC endpoint configuration, see: <https://docs.aws.amazon.com/secretsmanager/latest/userguide/troubleshoot.html>
