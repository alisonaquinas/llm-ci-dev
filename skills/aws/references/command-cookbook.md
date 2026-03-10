# AWS CLI Command Cookbook

## Preflight and Context

```bash
aws sts get-caller-identity
aws configure list-profiles
aws ec2 describe-instances --region us-east-1
aws s3api list-buckets
aws cloudformation list-stacks
```

## JMESPath Cheat Sheet

Query results using `--query` parameter. Common patterns:

### Projection (Select Fields)

```bash
# Select specific fields
aws ec2 describe-instances \
  --query 'Reservations[].Instances[].{Id:InstanceId,Type:InstanceType}' \
  --output table
```

### Filtering

```bash
# Filter by condition
aws ec2 describe-instances \
  --query 'Reservations[].Instances[?State.Name==`running`]' \
  --output table
```

### Multi-Select

```bash
# Select multiple fields in a hash
aws iam list-roles \
  --query 'Roles[].{Name:RoleName,Arn:Arn,Created:CreateDate}' \
  --output table
```

### Wildcard and Pipe

```bash
# Use * for all, pipe | for chaining operations
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].Tags[?Key==`Name`].Value' \
  --output text
```

### Default and Logic

```bash
# || for default value
aws ec2 describe-instances \
  --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`].Value|[0],Id:InstanceId}' \
  --output table

# Boolean operations
aws iam list-users \
  --query 'Users[?PasswordLastUsed!=null]' \
  --output table
```

## S3 Patterns

### List Buckets

```bash
aws s3api list-buckets --output table
aws s3api list-buckets --query 'Buckets[].Name' --output text
```

### List Objects

```bash
aws s3api list-objects-v2 --bucket my-bucket --output table
aws s3api list-objects-v2 --bucket my-bucket --recursive
```

### Copy Objects

```bash
# Single file
aws s3 cp s3://bucket/key.txt ./local/path/

# Directory (recursive)
aws s3 cp s3://bucket/prefix ./local/ --recursive

# Sync (update only changed files)
aws s3 sync s3://bucket/prefix ./local/
```

### Generate Presigned URLs

```bash
# Temporary download link (1 hour)
aws s3 presign s3://bucket/key.txt --expires-in 3600

# Presigned PUT (upload)
aws s3api generate-presigned-url \
  --cli-input-json file://presign-request.json
```

**Safety Note:** Never commit presigned URLs; they grant access.

## EC2 Patterns

### Describe Instances

```bash
# All running instances
aws ec2 describe-instances \
  --filters 'Name=instance-state-name,Values=running' \
  --output table

# By tag
aws ec2 describe-instances \
  --filters 'Name=tag:Environment,Values=production' \
  --output table

# Filter and extract info
aws ec2 describe-instances \
  --query 'Reservations[].Instances[?State.Name==`running`].{Id:InstanceId,Type:InstanceType,Ip:PrivateIpAddress}' \
  --output table
```

### Terminate Instances

```bash
# Single instance (dangerous — requires confirmation)
aws ec2 terminate-instances --instance-ids i-0123456789abcdef

# Multiple instances (batch)
aws ec2 terminate-instances --instance-ids i-111 i-222 i-333
```

## IAM Patterns

### Get Caller Identity

```bash
aws sts get-caller-identity
# Returns: Account, UserId, Arn
```

### List Roles

```bash
aws iam list-roles --output table
aws iam list-roles --query 'Roles[].{Name:RoleName,Arn:Arn}' --output table
```

### Assume Role (Cross-Account)

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/MyRole \
  --role-session-name my-session \
  --duration-seconds 3600

# Extract credentials for use in scripts
CREDS=$(aws sts assume-role ... --output json)
export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r '.Credentials.SessionToken')
```

## Lambda Patterns

### List Functions

```bash
aws lambda list-functions --output table
aws lambda list-functions --region us-west-2 --output table
```

### Invoke Function

```bash
# Synchronous (wait for response)
aws lambda invoke \
  --function-name my-function \
  --payload '{"key":"value"}' \
  response.json

cat response.json
```

### View Logs

```bash
aws logs tail /aws/lambda/my-function --follow
```

## CloudFormation Patterns

### Describe Stacks

```bash
aws cloudformation describe-stacks --stack-name my-stack --output table
aws cloudformation list-stack-resources --stack-name my-stack --output table
```

### Create/Update Stacks

```bash
# Create change set first (dry-run)
aws cloudformation create-change-set \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --change-set-name my-changes

# Review changes
aws cloudformation describe-change-set \
  --stack-name my-stack \
  --change-set-name my-changes

# Execute if satisfied
aws cloudformation execute-change-set \
  --stack-name my-stack \
  --change-set-name my-changes
```

## Output Formatting

### Always Use --no-cli-pager in Scripts

```bash
aws ec2 describe-instances --no-cli-pager --output json
```

### Common Output Formats

| Format | Use |
| --- | --- |
| `json` | Scripting, CI/CD |
| `table` | Human review |
| `text` | Column parsing |
| `yaml` | Configuration files |

## Environment Best Practices

- Use `--profile` for multi-account workflows
- Use `--region` explicitly in automation
- Use `--no-cli-pager` in scripts and CI/CD
- Always use `--query` to filter results in scripts (reduces parsing)
- Never commit AWS keys; use `~/.aws/credentials` and `~/.aws/config`
