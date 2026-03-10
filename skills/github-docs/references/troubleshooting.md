# GitHub Docs Troubleshooting

## Finding Error-Specific Documentation

When encountering a GitHub Actions error, follow these patterns:

### Workflow and Job Errors

Common error types and how to find docs:

1. **YAML syntax errors** — Check `https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions` for correct syntax
2. **Authentication failures** — See `https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication` for token handling
3. **Expression evaluation errors** — Consult `https://docs.github.com/en/actions/learn-github-actions/expressions` for syntax and available functions
4. **Secrets not working** — Check `https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions` for proper secret masking and usage
5. **Action not found** — Visit `https://docs.github.com/en/actions/learn-github-actions/finding-and-customizing-actions` to locate actions

### Runner and Execution Errors

1. **Self-hosted runner issues** — Start at `https://docs.github.com/en/actions/hosting-your-own-runners/monitoring-and-troubleshooting-self-hosted-runners`
2. **GitHub-hosted runner timeouts** — Check `https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners` for available runners and limits
3. **Concurrency constraints** — See `https://docs.github.com/en/actions/using-jobs/using-concurrency` for concurrency group configuration

### Search Strategy

If the specific error URL is unknown:

1. Start with the base Actions section: `/actions/`
2. Use WebFetch on `https://docs.github.com/en/actions` and search for keywords from the error
3. Check GitHub Discussions at `https://github.com/orgs/github/discussions/categories/actions` for crowd-sourced solutions
4. Review GitHub Status at `https://www.githubstatus.com/` for service incidents

## GitHub Enterprise Versions

If using GitHub Enterprise Server (GHES):

### How to Access GHES Documentation

Replace `/en` with `/en/enterprise-server@x.x` in URLs:

```text
https://docs.github.com/en/enterprise-server@3.10/actions/
https://docs.github.com/en/enterprise-server@3.9/rest/
https://docs.github.com/en/enterprise-server@3.8/actions/
```

### Supported GHES Versions

Current support includes:

- 3.10 (latest)
- 3.9
- 3.8
- 3.7

### Finding Version-Specific Docs

1. Visit `https://docs.github.com/en/enterprise-server@X.X/` (replace X.X with your version)
2. Look for version selector in top-left corner
3. Features may differ between versions; always consult your specific version docs

## Community Resources

| Resource | URL | Best For |
| --- | --- | --- |
| GitHub Discussions (Actions) | `https://github.com/orgs/github/discussions/categories/actions` | Questions and community support |
| GitHub Issues (GitHub) | `https://github.com/github/feedback/discussions` | Bug reports and feature requests |
| GitHub Community Forum | `https://github.community/` | General GitHub discussions |
| GitHub Status Page | `https://www.githubstatus.com/` | Service incidents and outages |
| GitHub Blog | `https://github.blog/` | New features and announcements |

## Navigation Tips

### Using the Docs Site Effectively

1. **Breadcrumb navigation**: Most docs pages show breadcrumb paths at the top
2. **Table of Contents**: Long pages have a TOC on the left side or in-page
3. **Search box**: Available in the top navigation; useful for keyword searches like "matrix" or "secret"
4. **Version switcher**: Top-left corner allows switching between versions and language variants
5. **Product switcher**: Navigate between GitHub, GitHub Enterprise, GitHub Actions, and other products

### Finding Specific Information

**Finding API endpoints**:

- Start at `https://docs.github.com/en/rest/`
- Use WebFetch to search for the resource type (repos, actions, pulls, issues, users)
- Each endpoint has full documentation with examples and parameters

**Finding workflow syntax keywords**:

- Go to `https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions`
- Use Ctrl+F to search for keywords (on, jobs, steps, runs-on, etc.)

**Finding context variables**:

- Base: `https://docs.github.com/en/actions/learn-github-actions/contexts`
- Includes `github.*` (repository, actor, event), `env.*`, `secrets.*`, `needs.*` variables
