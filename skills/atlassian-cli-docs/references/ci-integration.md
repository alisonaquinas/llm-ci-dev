# Atlassian CLI CI Integration Guide

Integration patterns and best practices for using ACLI in CI/CD pipelines.

## CI Integration Overview

ACLI integrates seamlessly into most CI platforms. The main integration guide is at:

`https://developer.atlassian.com/cloud/acli/guides/ci-pipeline-integration/`

## Authentication in CI Pipelines

### Setting Up API Token Authentication

1. Create a personal API token in Jira Cloud
2. Store token as a CI environment variable (e.g., `ACLI_API_TOKEN`, `JIRA_TOKEN`)
3. Use `jira auth login` with token, or pass directly to commands via flags

Reference: `https://developer.atlassian.com/cloud/acli/guides/getting-started/`

### CI Platform Patterns

| Platform | Auth Method | CI Variable Pattern |
| --- | --- | --- |
| GitHub Actions | Secrets | `${{ secrets.JIRA_TOKEN }}` |
| GitLab CI | Variables | `$JIRA_TOKEN` or `${JIRA_TOKEN}` |
| Jenkins | Credentials | `$JIRA_TOKEN` (injected) |
| CircleCI | Context variables | `$JIRA_TOKEN` |
| Bitbucket Pipelines | Repository variables | `$JIRA_TOKEN` |

## Command Chaining

Combine ACLI commands in a single workflow. Reference: `https://developer.atlassian.com/cloud/acli/guides/command-chaining/`

### Example Patterns

**Search and transition**:

```text
jira workitem search "project = PROJ and status = 'In Progress'"
jira workitem transition <issue-key> --status=Done
```

**Create issue from pipeline output**:

```text
ISSUE_KEY=$(jira workitem create --project=PROJ --title="Deploy failed")
jira workitem transition $ISSUE_KEY --status=In\ Progress
```

## Output Redirection

Capture and process ACLI output. Reference: `https://developer.atlassian.com/cloud/acli/guides/output-redirection/`

| Flag | Purpose | Example |
| --- | --- | --- |
| `--format=json` | JSON output for parsing | `jira workitem search ... --format=json` |
| `--format=csv` | CSV output for spreadsheets | `jira workitem list ... --format=csv` |
| `--format=table` | Human-readable table | `jira workitem list ... --format=table` |
| `> file.json` | Redirect to file | `jira workitem view KEY > output.json` |
| `\| jq` | Parse JSON with jq | `jira workitem search ... --format=json \| jq '.items[]'` |

## Shell Autocompletion

Enable command autocompletion in CI scripts for easier development:

`https://developer.atlassian.com/cloud/acli/guides/shell-autocompletion/`

## Common CI Use Cases

### Create Issue on Deployment Failure

| Use Case | ACLI Command | URL |
| --- | --- | --- |
| Create incident on deploy fail | `jira workitem create --project=OPS --type=Incident` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/create/` |
| Assign to on-call team | `jira workitem assign INCIDENT-123 --assignee=team-oncall` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/assign/` |
| Set priority | `jira workitem edit INCIDENT-123 --priority=High` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/edit/` |

### Transition Issues in Pipeline

| Use Case | ACLI Command | URL |
| --- | --- | --- |
| Move to "In Progress" | `jira workitem transition KEY --status="In Progress"` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/transition/` |
| Move to "Done" on success | `jira workitem transition KEY --status=Done` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/transition/` |
| Add comment on completion | `jira workitem comment KEY --text="Deployed to prod"` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/comment/` |

### Search Issues for Release Notes

| Use Case | ACLI Command | URL |
| --- | --- | --- |
| Find issues in release | `jira workitem search "fixVersion = v1.2.3"` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/search/` |
| Export as JSON | `jira workitem search "fixVersion = v1.2.3" --format=json` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/search/` |
| Filter by type | `jira workitem search "type IN (Feature, Bug) AND fixVersion = v1.2.3"` | `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/search/` |

### Update Sprint on Pipeline Success

| Use Case | ACLI Command | URL |
| --- | --- | --- |
| List active sprints | `jira sprint list --active` | `https://developer.atlassian.com/cloud/acli/reference/jira/sprint/list/` |
| Close sprint | `jira sprint close SPRINT-123` | `https://developer.atlassian.com/cloud/acli/reference/jira/sprint/close/` |
| Open sprint | `jira sprint open SPRINT-124` | `https://developer.atlassian.com/cloud/acli/reference/jira/sprint/open/` |

## Platform-Specific Examples

### GitHub Actions

Set secrets in GitHub UI (`Settings > Secrets`), then reference in workflow:

```yaml
- name: Create Jira issue
  env:
    JIRA_TOKEN: ${{ secrets.JIRA_TOKEN }}
  run: |
    jira auth login
    jira workitem create --project=PROJ --title="CI Build #${{ github.run_number }}"
```

Reference: CI Integration guide and GitHub Actions documentation

### GitLab CI

Store variables in GitLab UI (`Settings > CI/CD > Variables`):

```yaml
deploy_job:
  script:
    - jira auth login
    - jira workitem transition PROJ-123 --status=Done
  env:
    JIRA_TOKEN: $JIRA_TOKEN
```

Reference: CI Integration guide and GitLab CI documentation

### Jenkins

Inject credentials via Jenkins Credentials plugin:

```groovy
withCredentials([string(credentialsId: 'jira_token', variable: 'JIRA_TOKEN')]) {
  sh '''
    jira auth login
    jira workitem create --project=PROJ --title="Build #${BUILD_NUMBER}"
  '''
}
```

Reference: CI Integration guide and Jenkins documentation

## Troubleshooting in CI

Common issues and diagnostics:

`https://developer.atlassian.com/cloud/acli/guides/troubleshooting/`

| Issue | Diagnostics | URL |
| --- | --- | --- |
| Auth fails in CI | Check token in env var, verify permissions | `https://developer.atlassian.com/cloud/acli/guides/troubleshooting/` |
| Command not found | Verify ACLI installed in CI runner | `https://developer.atlassian.com/cloud/acli/guides/installation/` |
| Rate limiting | Implement backoff, reduce request volume | `https://developer.atlassian.com/cloud/acli/guides/troubleshooting/` |
| Timeout errors | Increase timeout, check network connectivity | `https://developer.atlassian.com/cloud/acli/guides/troubleshooting/` |
