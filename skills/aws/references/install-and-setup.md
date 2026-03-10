# AWS CLI v2 Install & Setup

## Prerequisites

- macOS 10.13+, Linux (Debian/Fedora/Arch), or Windows
- AWS account with IAM credentials (Access Key + Secret)
- Ability to use package manager or download installer

## Install by Platform

| macOS | Debian/Ubuntu | Fedora/RHEL | Windows |
| --- | --- | --- | --- |
| `brew install awscli` | See Linux note | See Linux note | `winget install Amazon.AWSCLI` |

**Linux:** AWS recommends the official installer:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## Post-Install Configuration

### Basic Configuration (Access Key method)

```bash
aws configure
```

Enter when prompted:

- **AWS Access Key ID:** From IAM (AWS console)
- **AWS Secret Access Key:** From IAM (save securely)
- **Default region:** `us-east-1` or your preferred region
- **Default output format:** `json`, `text`, or `table`

### SSO Configuration (recommended for teams)

```bash
aws configure sso
```

Enter:

- **SSO start URL:** From your organization
- **SSO region:** Usually `us-east-1`
- **Profile name:** e.g., `default` or `dev`

### Shell Completion (bash/zsh)

```bash
# Add to ~/.bashrc or ~/.zshrc:
complete -C '/usr/local/bin/aws_completer' aws

# Or for macOS (Homebrew):
eval "$(aws_completer)"
```

Then reload: `source ~/.bashrc`

## Verification

```bash
# Check version
aws --version

# Test authentication
aws sts get-caller-identity
```

Expected output shows your AWS account ID, ARN, and IAM user/role.

## Troubleshooting

### "Unable to locate credentials"

- Run `aws configure` to set up credentials.
- Or set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.

### "InvalidClientTokenId" or "SignatureDoesNotMatch"

- Access Key ID or Secret is incorrect. Regenerate in AWS IAM console.

### Permission denied on commands

- Your IAM user/role lacks necessary permissions.
- Check IAM policy in AWS console.

### Region issues

- Set default region: `aws configure set region us-west-2`
- Or use `--region us-west-2` flag on commands.
