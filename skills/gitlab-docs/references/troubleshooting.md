# GitLab Docs Troubleshooting

## Finding Error-Specific Documentation

When encountering a GitLab error, follow these patterns:

### Pipeline Errors

Common error codes and how to find docs:

1. **YAML parsing errors** — Check `https://docs.gitlab.com/ci/yaml/` for syntax
2. **Job timeout errors** — See `https://docs.gitlab.com/ci/yaml/#timeout` for timeout configuration
3. **Runner registration issues** — Visit `https://docs.gitlab.com/runner/install/` for setup
4. **Artifact path errors** — Consult `https://docs.gitlab.com/ci/yaml/#artifacts` for valid paths
5. **Image pull errors** — Check `https://docs.gitlab.com/ci/yaml/#image` and Docker authentication

### Search Strategy

If the specific error URL is unknown:

1. Start with the base section: `/ci/`, `/runner/`, `/administration/`, `/api/rest/`
2. Use WebFetch on the section page and search within the content
3. Check the GitLab community forum at `https://forum.gitlab.com/` for crowd-sourced solutions
4. Review the GitLab issue tracker at `https://gitlab.com/gitlab-org/gitlab/-/issues` for bug reports

## Version-Specific Documentation

GitLab releases a new major version every month. If documentation is outdated:

### How to Access Specific Versions

Append the version number to the URL:

```text
https://docs.gitlab.com/17.x/ci/yaml/
https://docs.gitlab.com/16.x/api/rest/
https://docs.gitlab.com/15.x/runner/install/
```

### When to Use Version-Specific Docs

- **Recent installations**: Use the current stable version (usually highest numbered)
- **Legacy systems**: If running GitLab 15.x, use `/15.x/` docs for compatibility
- **Migration guides**: Check `/17.x/` for breaking changes when upgrading

### Current Version Identifier

The default URL (without version) always points to the current stable/latest version. To find which version is documented:

1. Visit `https://docs.gitlab.com/`
2. Look for version selector in the top navigation
3. Select the version matching the installed GitLab instance

## Navigation Tips

### Using the Docs Site Effectively

1. **Breadcrumb navigation**: Most docs pages show breadcrumb paths at the top
2. **Table of Contents**: Long pages have a TOC on the right side
3. **Search box**: Available in the top-right; useful for keyword searches like "variable" or "artifact"
4. **Version switcher**: Top-left corner allows switching between versions

### Common Navigation Patterns

**Finding API endpoints**:

- Start at `https://docs.gitlab.com/api/rest/`
- Use WebFetch and search for the resource type (users, projects, pipelines, jobs)
- Append `.html` to construct direct links to specific endpoints

**Finding runner executors**:

- Go to `https://docs.gitlab.com/runner/executors/`
- Available executors: Shell, Docker, Docker Machine, Kubernetes, Parallels, VirtualBox, Custom

**Finding CI/CD templates**:

- Base: `https://docs.gitlab.com/ci/templates/`
- Language-specific: `.Net`, Java, Node.js, Python, Ruby, Go, etc.

## Community Resources

| Resource | URL | Best For |
| --- | --- | --- |
| GitLab Community Forum | `https://forum.gitlab.com/` | Questions, discussions, community advice |
| GitLab Issue Tracker | `https://gitlab.com/gitlab-org/gitlab/-/issues` | Bug reports, feature requests, known issues |
| Runner Issues | `https://gitlab.com/gitlab-org/gitlab-runner/-/issues` | Runner-specific bugs |
| Docs Issues | `https://gitlab.com/gitlab-org/gitlab-docs/-/issues` | Documentation bugs or suggestions |
