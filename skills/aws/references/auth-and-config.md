# AWS CLI Authentication and Configuration

## Credential Chain Order

AWS CLI searches for credentials in this order (first match wins):

1. **Command-line options** — `--profile`, `--access-key-id`, `--secret-access-key`
2. **Environment variables** — `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`
3. **Named profiles** — `~/.aws/credentials` and `~/.aws/config`
4. **Instance metadata** — On EC2/ECS, fetches from metadata service
5. **Container credentials** — ECS task role or similar

The first credential set found is used; subsequent sources are ignored.

## aws configure Setup

### Interactive Configuration

```bash
aws configure

# Prompts for:
# AWS Access Key ID: [paste key]
# AWS Secret Access Key: [paste secret]
# Default region: us-east-1
# Default output format: json
```

Creates/updates:

- `~/.aws/credentials` — access keys
- `~/.aws/config` — region and output format

### SSO Configuration

```bash
aws configure sso

# Prompts for:
# SSO session name: mycompany
# SSO start URL: https://mycompany.awsapps.com/start
# SSO region: us-east-1
# Account ID: 123456789012
# Role name: Developer
```

Stores SSO configuration in `~/.aws/config` and caches tokens locally.

## SSO Login Flow

### Step 1: Initiate Login

```bash
aws sso login --profile mycompany-dev
```

Opens browser automatically. Authenticate with your SSO provider (Okta, Azure AD, etc.)

### Step 2: Browser Redirect

Browser confirms authorization and redirects back with temporary credentials.

### Step 3: Token Cached Locally

Credentials cached in `~/.aws/sso/cache/` for duration of session (usually 12 hours).

### Subsequent Calls

Subsequent AWS CLI calls use cached token:

```bash
aws s3 ls --profile mycompany-dev
# Uses cached SSO token, no re-auth needed
```

### Token Expiration

```bash
# Check token status
aws sts get-caller-identity --profile mycompany-dev

# If expired:
# [ERROR] InvalidToken.ExpiredToken
# Solution: Re-login
aws sso login --profile mycompany-dev
```

## MFA: Multi-Factor Authentication

### Get Session Token with MFA

```bash
aws sts get-session-token \
  --serial-number arn:aws:iam::123456789012:mfa/username \
  --token-code 123456  # Current MFA code from authenticator app
```

Returns temporary credentials:

```json
{
  "Credentials": {
    "AccessKeyId": "ASIAJXXXXXXX",
    "SecretAccessKey": "...",
    "SessionToken": "...",
    "Expiration": "2026-03-09T15:00:00Z"
  }
}
```

### Use Session Token in Profile

Add to `~/.aws/credentials`:

```ini
[default]
aws_access_key_id = ASIAJXXXXXXX
aws_secret_access_key = ...
aws_session_token = ...
```

### Assume Role with MFA

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/MyRole \
  --role-session-name my-session \
  --serial-number arn:aws:iam::123456789012:mfa/username \
  --token-code 123456
```

## Named Profiles

### Profile File Format

`~/.aws/config`:

```ini
[default]
region = us-east-1
output = json

[profile production]
region = us-west-2
output = table

[profile sso-dev]
sso_start_url = https://mycompany.awsapps.com/start
sso_region = us-east-1
sso_account_id = 987654321098
sso_role_name = Developer
```

`~/.aws/credentials`:

```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[production]
aws_access_key_id = ASIAJXXXXXXX
aws_secret_access_key = ...
aws_session_token = ...
```

### Using Profiles

```bash
# Default profile
aws s3 ls

# Named profile via flag
aws s3 ls --profile production

# Named profile via environment
export AWS_PROFILE=production
aws s3 ls
```

### Profile Precedence

`--profile` flag **overrides** `AWS_PROFILE` environment variable.

## LocalStack for Local Development

### Start LocalStack

```bash
docker run -d -p 4566:4566 localstack/localstack
# Or: localstack start
```

### Point CLI to LocalStack

```bash
aws s3 ls \
  --endpoint-url http://localhost:4566 \
  --region us-east-1
```

### Per-Profile LocalStack

`~/.aws/config`:

```ini
[profile local]
region = us-east-1
output = json
```

Script:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
aws s3 ls --endpoint-url http://localhost:4566 --profile local
```

## Troubleshooting

### Expired Credentials

**Error:**

```output
[ERROR] ExpiredToken: The provided token has expired.
```

**Solution:**

- SSO: `aws sso login --profile <name>`
- MFA: Get new session token with `aws sts get-session-token`
- Refresh env vars if using temporary credentials

### Region Not Set

**Error:**

```output
[ERROR] You must specify a region. You can also configure
your region by running "aws configure".
```

**Solution:**

```bash
# Option 1: Command line
aws s3 ls --region us-east-1

# Option 2: Environment
export AWS_DEFAULT_REGION=us-east-1

# Option 3: Profile config
aws configure --profile myprofile
```

### MFA Required

**Error:**

```output
[ERROR] User: ... is not authorized to perform: sts:AssumeRole
because no MFA device is associated with this user.
```

**Solution:**

1. Provide `--serial-number` and `--token-code` to `assume-role`
2. Or first get session token: `aws sts get-session-token --serial-number ... --token-code ...`

### NoCredentialProviders

**Error:**

```output
[ERROR] Unable to locate credentials. You can configure credentials
by running "aws configure".
```

**Solution:**

1. Check credential chain: `aws sts get-caller-identity`
2. Run `aws configure` to add credentials
3. Or set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` env vars
4. Or use IAM role on EC2 instance
