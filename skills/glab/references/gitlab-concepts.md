# GitLab Concepts and Organization

## Groups vs Projects: Namespace Anatomy

GitLab organizes repositories and resources in a hierarchical namespace structure.

### Namespace Paths

```text
group/                    # Group (can contain projects)
group/project1            # Project in group
group/subgroup/           # Nested subgroup
group/subgroup/project2   # Project in nested group
user/my-project           # Personal project in user namespace
```

### Groups

- Container for multiple projects
- Share settings, permissions, and runners
- Can be nested to any depth
- Example: `my-company/engineering/backend`

### Projects

- Git repository with CI/CD, issues, MRs
- Belongs to exactly one group or user namespace
- Identified by full path: `group/subgroup/project`

### Personal Projects

Projects under your user namespace:

```text
@username/my-project
```

Can be in personal space or within groups you own.

## Naming: Personal vs Group-Owned

### Personal Project

```bash
glab repo create my-project
# Creates: @username/my-project
```

### Group-Owned Project

```bash
glab repo create --group "my-company/engineering" my-project
# Creates: my-company/engineering/my-project
```

## Namespaced Paths in glab Commands

Commands use full namespace path:

```bash
# By full path
glab issue list --repo group/subgroup/project

# By group-level command
glab issue list --repo my-company

# Short form if in repo directory
cd my-project
glab issue list
```

### Finding Full Path

```bash
glab project list
# Output includes full paths like "my-company/engineering/backend"

glab project view my-project
# Shows: path: my-company/engineering/my-project
```

## PAT vs OAuth vs CI Job Tokens

### Personal Access Token (PAT)

- User-controlled credential
- Full permissions of creating user
- Long-lived (until revoked)
- Use in: scripts, CI/CD, local automation

```bash
glab auth login
# Prompts for PAT
# Stored in ~/.config/glab/config.yml
```

### OAuth Token

- OAuth2 application authorization
- User grants specific scopes
- Can be revoked by user
- Use in: web applications, delegated access

### CI Job Token

- Automatically provided in CI/CD pipeline
- Only valid during job execution
- Limited scope (can access project resources)
- Use in: pipeline scripts, inter-project access

```bash
# In CI pipeline
export CI_JOB_TOKEN="<auto-provided>"
glab api projects/$CI_PROJECT_ID/issues
```

## Protected Branches and Merge Request Rules

### Protected Branch Setup

```bash
glab protected-branch create \
  --repo group/project \
  main \
  --require-approvals 2 \
  --require-status-checks
```

### Approval Rules

```bash
# Require 2 approvals before merge
glab protected-branch create main --require-approvals 2

# Require specific user approval
glab protected-branch create main --require-code-owner-approval
```

### Push Restrictions

Protected branches prevent:

- Direct commits (must use MR)
- Force push
- Deletion

### Enforcement

All MR to protected branch must:

1. Pass status checks
2. Get required approvals
3. Have updated target branch

## GitLab Runners

### Shared Runners

- Provided by GitLab instance
- Available to all projects
- Managed by administrators
- Use: `tags: [shared]` in `.gitlab-ci.yml`

### Group Runners

- Shared within group and subgroups
- Configured at group level
- Use: `tags: [group-runner]` in `.gitlab-ci.yml`

### Project-Specific Runners

- Run jobs only for one project
- Installed and managed per-project
- Use: `tags: [specific-runner]` in `.gitlab-ci.yml`

### List Available Runners

```bash
glab runner list
# Shows: id, description, tags, last used
```

## Visibility Levels

| Level | Who Can See | Use Case |
| --- | --- | --- |
| Public | Anyone on internet | Open source projects |
| Internal | Authenticated users | Team-internal projects |
| Private | Project members only | Confidential projects |

### Visibility in Commands

```bash
# Create private project
glab repo create --visibility private my-project

# Change visibility
glab project update group/project --visibility internal
```

## Environment Variables in CI/CD

### Built-in Variables (Automatically Provided)

| Variable | Value | Example |
| --- | --- | --- |
| `CI_PROJECT_ID` | Numeric project ID | `12345` |
| `CI_PROJECT_PATH` | Full project path | `group/subgroup/project` |
| `CI_JOB_TOKEN` | Job-scoped token | Auto-provided, short-lived |
| `CI_COMMIT_SHA` | Current commit hash | `abcdef123456` |
| `CI_COMMIT_BRANCH` | Current branch | `main` |
| `CI_MERGE_REQUEST_IID` | MR number (if in MR pipeline) | `42` |

### Custom Variables

Set in `.gitlab-ci.yml`:

```yaml
variables:
  API_TOKEN: $SECRET_TOKEN  # Reference secrets
  BUILD_ENV: production
```

Or in project settings → CI/CD → Variables

### Masking Secrets

```yaml
variables:
  DB_PASSWORD:
    value: "secret123"
    protected: true
    masked: true  # Hidden in logs
```

## Troubleshooting

### Auth Host Mismatch

**Error:**

```output
[ERROR] Host mismatch. Expected: gitlab.com, Got: gitlab.example.com
```

**Solution:**

```bash
# Logout and login to correct host
glab auth logout gitlab.com
glab auth login --hostname gitlab.example.com
```

### Repo Not Found

**Error:**

```output
[ERROR] project not found
```

**Solution:**

1. Verify full path: `glab project list | grep name`
2. Check access: `glab project view group/project`
3. Verify visibility: `glab project view --format json | grep visibility`

### Permission Denied on Protected Branch

**Error:**

```output
[ERROR] You do not have permission to push code to this project
```

**Solution:**

1. Check your role: `glab member list --repo group/project`
2. Request access via web UI or ask project maintainer
3. Protected branches require MR (not direct push)
