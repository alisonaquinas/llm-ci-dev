# GitLab CLI (glab) Install & Setup

## Prerequisites

- macOS 10.13+, Linux (Debian/Fedora/Arch), or Windows
- GitLab account (gitlab.com or self-hosted instance)
- GitLab API token (created in account settings)

## Install by Platform

| macOS | Debian/Ubuntu | Fedora/RHEL | Windows |
| --- | --- | --- | --- |
| `brew install glab` | See Linux note | `dnf install glab` | `winget install --id=glab-cli.glab` |

**Debian/Ubuntu:** Add GitLab apt repository:

```bash
curl -s https://repo.gitlab.com/api/v4/projects/gitlab-org%2Fglabcli/packages/debian/distributions | sh
apt install glab
```

## Post-Install Configuration

### Authenticate with GitLab

```bash
# Interactive login (recommended)
glab auth login --hostname gitlab.com

# When prompted:
# - Choose "SSH" or "HTTPS"
# - Paste your GitLab API token (from Settings > Access Tokens)
# - Confirm
```

### Generate GitLab Token

If you don't have a token:

1. Go to <https://gitlab.com/-/user_settings/personal_access_tokens> (or your self-hosted instance)
2. Click "Add new token"
3. Set name, expiration, and scopes:
   - `api` — Full API access (required for most operations)
   - `read_user` — Read user profile
   - `read_repository` — Read repository content
4. Click "Create personal access token"
5. Copy the token (won't show again)

### Configure for Self-Hosted GitLab

```bash
# Set host for self-hosted instance
glab config set host gitlab.example.com

# Or during auth
glab auth login --hostname gitlab.example.com
```

### Verify Authentication

```bash
glab auth status

# Expected output shows your GitLab user and host
```

## Common Commands

```bash
# Clone repo
glab repo clone <namespace>/<project>

# Create merge request
glab mr create -t "feat: add feature"

# List open MRs
glab mr list

# View MR details
glab mr view <mr-id>

# List issues
glab issue list

# Check pipeline status
glab pipeline list
```

## Troubleshooting

### "401 Unauthorized"

- Token is invalid or expired. Regenerate in GitLab Settings > Access Tokens.

### "glab: command not found"

- Installation incomplete. Re-run install for your platform.

### "dial unix /run/user/1000/keyring-*: no such file or directory"

- Credential store issue (usually on Linux). Run:

  ```bash
  glab auth login --hostname gitlab.com --stdin < token.txt
  ```

### Self-hosted instance not recognized

- Ensure config is set: `glab config set host gitlab.example.com`
- Test: `glab auth status`
