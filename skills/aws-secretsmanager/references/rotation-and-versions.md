# AWS Secrets Manager Rotation and Versions

## Automatic Rotation Overview

Secrets Manager can automatically rotate secrets by invoking a Lambda function on a schedule. When rotation runs, the Lambda updates the credential in both the target service (e.g., an RDS database) and in Secrets Manager.

## Staging Labels

Each version of a secret carries one or more staging labels:

| Label | Meaning |
| --- | --- |
| `AWSCURRENT` | The current active version — returned by default |
| `AWSPENDING` | The new version being rotated in |
| `AWSPREVIOUS` | The previous version (kept for rollback during rotation) |

Custom labels can also be assigned.

## Version Management Commands

```bash
# List all version IDs and their labels
aws secretsmanager list-secret-version-ids \
  --secret-id "myapp/prod/db-password"

# Get a specific staging label
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-password" \
  --version-stage AWSPREVIOUS

# Get a specific version by ID
aws secretsmanager get-secret-value \
  --secret-id "myapp/prod/db-password" \
  --version-id "<version-uuid>"

# Move a staging label from one version to another
aws secretsmanager update-secret-version-stage \
  --secret-id "myapp/prod/db-password" \
  --version-stage AWSCURRENT \
  --move-to-version-id "<new-version-uuid>" \
  --remove-from-version-id "<old-version-uuid>"
```

## Enabling Automatic Rotation

```bash
# Enable rotation with an existing Lambda and a 30-day schedule
aws secretsmanager rotate-secret \
  --secret-id "myapp/prod/db-password" \
  --rotation-lambda-arn "arn:aws:lambda:us-east-1:123456789012:function:MyRotationFunction" \
  --rotation-rules AutomaticallyAfterDays=30

# Trigger an immediate rotation
aws secretsmanager rotate-secret \
  --secret-id "myapp/prod/db-password"

# Disable automatic rotation
aws secretsmanager cancel-rotate-secret \
  --secret-id "myapp/prod/db-password"
```

## Built-In Rotation Functions

AWS provides managed Lambda rotation functions for common database engines:

| Service | Lambda ARN Pattern |
| --- | --- |
| Amazon RDS (single user) | `arn:aws:serverlessrepo:us-east-1:912272126622:applications/SecretsManagerRDSMySQLRotationSingleUser` |
| Amazon RDS (multi user) | Similar, replace `SingleUser` with `MultiUser` |
| Amazon Redshift | `SecretsManagerRedshiftRotationSingleUser` |
| Amazon DocumentDB | `SecretsManagerDocumentDBRotationSingleUser` |

Deploy these via the AWS Serverless Application Repository (SAR) in the AWS console.

## Custom Lambda Rotation Function Structure

A custom rotation Lambda must implement four steps called by Secrets Manager:

1. **createSecret** — generate a new credential and store it as `AWSPENDING`
2. **setSecret** — set the `AWSPENDING` credential in the target system
3. **testSecret** — verify the `AWSPENDING` credential works
4. **finishSecret** — move `AWSPENDING` to `AWSCURRENT`

```python
import boto3

def lambda_handler(event, context):
    step = event['Step']
    secret_id = event['SecretId']
    token = event['ClientRequestToken']

    client = boto3.client('secretsmanager')

    if step == 'createSecret':
        # Generate and store AWSPENDING version
        pass
    elif step == 'setSecret':
        # Apply AWSPENDING credential to the target service
        pass
    elif step == 'testSecret':
        # Verify the AWSPENDING credential
        pass
    elif step == 'finishSecret':
        # Promote AWSPENDING to AWSCURRENT
        client.update_secret_version_stage(
            SecretId=secret_id,
            VersionStage='AWSCURRENT',
            MoveToVersionId=token,
            RemoveFromVersionId=<current-version-id>
        )
```

## Monitoring Rotation with CloudTrail

```bash
# Search CloudTrail for rotation events
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=RotateSecret \
  --query 'Events[].{Time:EventTime,Who:Username,Secret:Resources[0].ResourceName}'

# Find failed rotations
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=RotationFailed
```

For advanced rotation patterns, see: <https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/>
