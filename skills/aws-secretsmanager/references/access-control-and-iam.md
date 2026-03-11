# AWS Secrets Manager Access Control and IAM

## Identity-Based Policies (Least-Privilege Templates)

### Read-Only Access to a Path Prefix

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ReadSecretsForApp",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": "arn:aws:secretsmanager:us-east-1:123456789012:secret:myapp/prod/*"
    }
  ]
}
```

### Create and Manage Secrets (DevOps Role)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ManageAppSecrets",
      "Effect": "Allow",
      "Action": [
        "secretsmanager:CreateSecret",
        "secretsmanager:PutSecretValue",
        "secretsmanager:UpdateSecret",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecrets",
        "secretsmanager:TagResource"
      ],
      "Resource": "arn:aws:secretsmanager:us-east-1:123456789012:secret:myapp/*"
    }
  ]
}
```

### Allow Rotation Lambda

```json
{
  "Sid": "AllowRotation",
  "Effect": "Allow",
  "Action": [
    "secretsmanager:GetSecretValue",
    "secretsmanager:PutSecretValue",
    "secretsmanager:DescribeSecret",
    "secretsmanager:UpdateSecretVersionStage"
  ],
  "Resource": "arn:aws:secretsmanager:us-east-1:123456789012:secret:myapp/prod/db*"
}
```

## Resource-Based Policies (Cross-Account Access)

Attach a resource-based policy directly to a secret to grant access to another AWS account:

```bash
# View current resource policy
aws secretsmanager get-resource-policy \
  --secret-id "myapp/prod/db-password"

# Set a resource-based policy (allows cross-account read)
POLICY=$(cat <<'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CrossAccountRead",
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::999999999999:role/ExternalRole"},
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
EOF
)

aws secretsmanager put-resource-policy \
  --secret-id "myapp/prod/db-password" \
  --resource-policy "$POLICY"

# Remove resource policy
aws secretsmanager delete-resource-policy \
  --secret-id "myapp/prod/db-password"
```

## KMS Key Policies for CMK-Encrypted Secrets

When using a customer-managed KMS key, the key policy must grant permissions to the principals that access the secret:

```json
{
  "Sid": "AllowSecretsManagerUse",
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::123456789012:role/AppRole"
  },
  "Action": [
    "kms:Decrypt",
    "kms:GenerateDataKey"
  ],
  "Resource": "*",
  "Condition": {
    "StringEquals": {
      "kms:ViaService": "secretsmanager.us-east-1.amazonaws.com"
    }
  }
}
```

## Tag-Based Access Control

```json
{
  "Sid": "ReadByTag",
  "Effect": "Allow",
  "Action": "secretsmanager:GetSecretValue",
  "Resource": "*",
  "Condition": {
    "StringEquals": {
      "secretsmanager:ResourceTag/Environment": "prod",
      "secretsmanager:ResourceTag/App": "myapp"
    }
  }
}
```

## CloudTrail Audit Logging

All Secrets Manager API calls are logged to CloudTrail by default.

```bash
# Look up GetSecretValue calls
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=GetSecretValue \
  --query 'Events[].{Time:EventTime,Who:Username,Secret:Resources[0].ResourceName}'

# Look up unauthorized access attempts
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=GetSecretValue \
  --query 'Events[?ErrorCode!=`null`]'
```

## VPC Endpoint for Private Access

Accessing Secrets Manager from a VPC without internet access requires an interface VPC endpoint:

```bash
# Create interface endpoint for Secrets Manager
aws ec2 create-vpc-endpoint \
  --vpc-id "<vpc-id>" \
  --service-name "com.amazonaws.us-east-1.secretsmanager" \
  --vpc-endpoint-type Interface \
  --subnet-ids "<subnet-id>" \
  --security-group-ids "<sg-id>" \
  --private-dns-enabled

# Verify endpoint
aws ec2 describe-vpc-endpoints \
  --filters Name=service-name,Values=com.amazonaws.us-east-1.secretsmanager
```

For advanced IAM and access control patterns, see: <https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/>
