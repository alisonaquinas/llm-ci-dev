# GitLab Docs Troubleshooting

## Finding Error-Specific Documentation

When encountering a GitLab error, follow these patterns:

### Pipeline Errors

Common error codes and how to find docs:

1. **YAML parsing errors** — Check `https://docs.gitlab.com/ci/yaml/` for syntax
2. **Job timeout errors** — See `https://docs.gitlab.com/ci/yaml/#timeout` for timeout configuration
3. **Runner registration token rejected** — Registration tokens are deprecated; create runners with the authentication-token workflow at `https://docs.gitlab.com/ci/runners/new_creation_workflow/`
4. **Artifact path errors** — Consult `https://docs.gitlab.com/ci/yaml/#artifacts` for valid paths
5. **Image pull errors** — Check `https://docs.gitlab.com/ci/yaml/#image` and Docker authentication
6. **Job log debugging** — See `https://docs.gitlab.com/administration/cicd/job_logs/` for log retention, troubleshooting tail/incremental logs, and self-managed configuration
7. **Pipeline ran with empty changes** — Migrate `only`/`except` rules to `rules:` per `https://docs.gitlab.com/ci/yaml/#rules`; legacy `only`/`except` no longer composes cleanly with `workflow:rules`

### Search Strategy

If the specific error URL is unknown:

1. Start with the base section: `/ci/`, `/runner/`, `/administration/`, `/api/rest/`
2. Use WebFetch on the section page and search within the content
3. Check the GitLab community forum at `https://forum.gitlab.com/` for crowd-sourced solutions
4. Review the GitLab issue tracker at `https://gitlab.com/gitlab-org/gitlab/-/issues` for bug reports

## Version-Specific Documentation

GitLab releases a new major version every month. If documentation is outdated:

### How to Access Specific Versions

Insert the GitLab version segment between the base URL and the path:

```text
https://docs.gitlab.com/<version>/ci/yaml/
https://docs.gitlab.com/<version>/api/rest/
https://docs.gitlab.com/<version>/runner/install/
```

### When to Use Version-Specific Docs

- **Recent installations**: Omit the version segment — `https://docs.gitlab.com/` serves the current stable release.
- **Legacy systems**: Insert the matching `<version>` segment for the GitLab release the instance is actually running.
- **Migration guides**: Read the release-notes page on the current stable docs to find breaking changes when upgrading.

### Current Version Identifier and Supported Releases

- The default URL (no version segment) always points to the current stable / latest release.
- The canonical supported-release list (with end-of-life dates) is at `https://docs.gitlab.com/ee/policy/maintenance.html`.
- To find which version is currently documented as default: visit `https://docs.gitlab.com/` and read the version selector in the top navigation.

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
