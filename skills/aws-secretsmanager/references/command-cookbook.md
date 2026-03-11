# AWS Secrets Manager Command Cookbook

## Creating Secrets

```bash
# Create a plain text secret
aws secretsmanager create-secret \
  --name "myapp/prod/api-key" \
  --secret-string "abc123"

# Create a JSON key-value secret
aws secretsmanager create-secret \
  --name "myapp/prod/db-credentials" \
  --secret-string '{"username":"admin","password":"s3cr3t"}'

# Create with a description and tags
aws secretsmanager create-secret \
  --name "myapp/prod/db-password" \
  --description "Production DB password" \
  --secret-string "s3cr3t" \
  --tags Key=Environment,Value=prod Key=App,Value=myapp

# Create with a customer-managed KMS key
aws secretsmanager create-secret \
  --name "myapp/prod/db-password" \
  --kms-key-id "alias/my-key" \
  --secret-string "s3cr3t"
```

## Retrieving Secrets

```bash
# Get the full secret value (JSON response)
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-password"

# Get only the secret string (no metadata)
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-password" \
  --query SecretString \
  --output text

# Parse a JSON secret with jq
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-credentials" \
  --query SecretString \
  --output text | jq -r '.password'

# Get a specific version
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-password" \
  --version-id "<version-uuid>"

# Get a specific staging label
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-password" \
  --version-stage AWSPREVIOUS
```

## Updating Secrets

```bash
# Replace the secret value (creates a new version)
aws secretsmanager put-secret-value \
  --secret-id "myapp/prod/db-password" \
  --secret-string "n3wpassword"

# Update metadata (description, KMS key) — not the value
aws secretsmanager update-secret \
  --secret-id "myapp/prod/db-password" \
  --description "Updated description"
```

## Describing and Listing Secrets

```bash
# Describe a secret (metadata, rotation config, ARN)
aws secretsmanager describe-secret \
  --secret-id "myapp/prod/db-password"

# List all secrets in the region
aws secretsmanager list-secrets

# List secrets with a name filter
aws secretsmanager list-secrets \
  --filters Key=name,Values=myapp/prod

# List version IDs for a secret
aws secretsmanager list-secret-version-ids \
  --secret-id "myapp/prod/db-password"
```

## Deleting Secrets

```bash
# Delete with a 7-day recovery window (default is 30 days)
aws secretsmanager delete-secret \
  --secret-id "myapp/prod/db-password" \
  --recovery-window-in-days 7

# Delete immediately with no recovery window (IRREVERSIBLE)
aws secretsmanager delete-secret \
  --secret-id "myapp/prod/db-password" \
  --force-delete-without-recovery

# Restore a secret scheduled for deletion
aws secretsmanager restore-secret \
  --secret-id "myapp/prod/db-password"
```

## Tagging

```bash
# Add tags to a secret
aws secretsmanager tag-resource \
  --secret-id "myapp/prod/db-password" \
  --tags Key=Owner,Value=platform-team

# Remove tags
aws secretsmanager untag-resource \
  --secret-id "myapp/prod/db-password" \
  --tag-keys Owner
```

## Rotation

```bash
# Trigger an immediate manual rotation
aws secretsmanager rotate-secret \
  --secret-id "myapp/prod/db-password"

# Enable automatic rotation with a schedule
aws secretsmanager rotate-secret \
  --secret-id "myapp/prod/db-password" \
  --rotation-lambda-arn "arn:aws:lambda:us-east-1:123456789012:function:MyRotator" \
  --rotation-rules AutomaticallyAfterDays=30
```

## Multi-Region Replication

```bash
# Replicate a secret to another region
aws secretsmanager replicate-secret-to-regions \
  --secret-id "myapp/prod/db-password" \
  --add-replica-regions Region=eu-west-1

# List replica regions
aws secretsmanager describe-secret \
  --secret-id "myapp/prod/db-password" \
  --query ReplicationStatus
```

## Common jq Patterns

```bash
# Extract password from a JSON secret
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-creds" \
  --query SecretString --output text | jq -r '.password'

# Export all secrets names
aws secretsmanager list-secrets --query 'SecretList[].Name' --output text

# Find secrets expiring within 7 days
aws secretsmanager list-secrets --output json | \
  jq '.SecretList[] | select(.RotationEnabled==true) | .Name'
```
