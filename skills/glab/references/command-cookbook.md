# GitLab CLI Command Cookbook

## Preflight and Context

```bash
glab auth status
glab repo view
glab project list
glab issue list
glab mr list
glab ci list
```

## Merge Request Workflows

### Create Merge Request

```bash
# Basic create
glab mr create --title "Add feature X" --description "This PR adds..."

# With assignees and labels
glab mr create \
  --title "Fix bug" \
  --description "Closes #123" \
  --assignee @user1 \
  --assignee @user2 \
  --label bug \
  --label urgent

# With target branch
glab mr create \
  --title "Feature" \
  --target-branch develop
```

### List and Filter MRs

```bash
# All open MRs
glab mr list --output table

# By state
glab mr list --state opened
glab mr list --state merged
glab mr list --state closed

# By assignee
glab mr list --assignee @me

# By label
glab mr list --label "needs-review"
```

### MR Operations

```bash
# Assign reviewers
glab mr review <id> --assignee @reviewer

# Add approvers
glab mr approve <id>

# Merge MR
glab mr merge <id>

# Merge with squash
glab mr merge <id> --squash

# Close without merging
glab mr close <id>

# View MR details
glab mr view <id>

# View MR discussions
glab mr comments <id>
```

## Issue Workflows

### Create Issue

```bash
# Basic create
glab issue create --title "Bug: Login broken"

# Full metadata
glab issue create \
  --title "Feature request" \
  --description "Add dark mode support" \
  --assignee @user \
  --label feature \
  --milestone "v2.0"
```

### List and Filter Issues

```bash
# All open issues
glab issue list --output table

# By state
glab issue list --state opened
glab issue list --state closed

# By label
glab issue list --label "type/bug"

# Assigned to me
glab issue list --assignee @me

# Recent activity
glab issue list --order-by updated_at
```

### Issue Operations

```bash
# Assign issue
glab issue update <id> --assignee @user

# Add labels
glab issue update <id> --label bug --label critical

# Close issue
glab issue close <id>

# Reopen issue
glab issue reopen <id>

# Add note/comment
glab issue note <id> "Fix released in v1.2.3"

# View details
glab issue view <id>
```

## CI/CD Patterns

### List and View Pipelines

```bash
# Recent pipelines
glab ci list --output table

# By branch
glab ci list --branch main

# View pipeline status
glab ci view

# View job log
glab ci trace <job-id>
```

### Pipeline Operations

```bash
# Retry failed pipeline
glab ci retry

# Cancel running pipeline
glab ci cancel

# View job artifacts
glab ci artifacts <job-id>

# Download artifact
glab ci artifacts <job-id> --path "coverage/"
```

## Release Workflows

### Create Release

```bash
glab release create v1.0.0 \
  --notes "Release notes text"

# With description file
glab release create v1.0.0 \
  --notes-file RELEASE_NOTES.md
```

### List Releases

```bash
glab release list --output table

# View specific release
glab release view v1.0.0
```

### Upload Release Assets

```bash
# Add file to release
glab release upload v1.0.0 ./build/app.tar.gz

# Add multiple files
glab release upload v1.0.0 ./dist/* ./checksums.txt
```

## API Patterns

### Direct API Calls

```bash
# GraphQL query
glab api graphql -f query='query { user { name } }'

# REST API
glab api projects/:id/merge_requests

# With filters
glab api projects/:id/issues --query state=opened

# Get user info
glab api user --query username

# List project members
glab api projects/:id/members
```

### REST API Examples

```bash
# Create issue via API
glab api projects/:id/issues \
  --input issues.json

# Update merge request
glab api projects/:id/merge_requests/:mr-iid \
  -X PUT \
  --input mr-update.json
```

## Repository Navigation

### View Repository Info

```bash
glab repo view
glab repo view --repo group/project
```

### List Projects

```bash
# User projects
glab project list --output table

# Group projects
glab project list --group my-company

# Owned by me
glab project list --owned
```

## Context and Authentication

### Check Auth Status

```bash
glab auth status
glab auth status --hostname gitlab.example.com
```

### Switch Hosts

```bash
# List configured hosts
glab auth list

# Login to new host
glab auth login --hostname gitlab.example.com

# Set default host
glab config set host gitlab.example.com
```

## Output and Formatting

### Format Options

```bash
# Table format (human-readable)
glab issue list --output table

# JSON (for scripting)
glab issue list --output json

# Custom format with `jq`
glab issue list --output json | jq '.[] | {id, title}'
```

## Best Practices

- Always verify context before running mutations: `glab auth status`
- Use `--repo group/project` explicitly in automation (don't rely on CWD)
- Use `--token <PAT>` for CI/CD (do not hardcode; use CI variables)
- Enable `CI_JOB_TOKEN` in pipelines when available
- Use MR template for consistent descriptions
- Tag releases with semantic versioning (v1.0.0)
