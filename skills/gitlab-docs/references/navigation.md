# GitLab Docs Site Navigation

## Structure Overview

docs.gitlab.com is organized into major product sections:

### Top-Level Sections

| Section | Base URL | Contents |
| --- | --- | --- |
| **User** | `https://docs.gitlab.com/user/` | Projects, repositories, merge requests, issues, wiki, snippets, and user features |
| **CI/CD** | `https://docs.gitlab.com/ci/` | Pipelines, jobs, stages, runners, variables, caching, artifacts, triggers, merge request pipelines |
| **Runner** | `https://docs.gitlab.com/runner/` | Installation, configuration, executors (Docker, Kubernetes, Shell), advanced setup |
| **Administration** | `https://docs.gitlab.com/administration/` | System settings, users, groups, permissions, audit logs, backup/restore, security |
| **Development** | `https://docs.gitlab.com/development/` | Contributing to GitLab, API design, frontend/backend architecture |
| **API** | `https://docs.gitlab.com/api/rest/` | REST API reference, authentication, pagination, webhooks, GraphQL |
| **Integration** | `https://docs.gitlab.com/integration/` | Third-party integrations, webhooks, external services |

### Version Selector Pattern

GitLab docs support version-specific documentation. The URL pattern is:

```text
https://docs.gitlab.com/<version>/<path>
```

The **current stable** version is served when no version segment is present —
`https://docs.gitlab.com/ci/yaml/` always points at the latest GA release.

For an older release, insert the matching version segment:

```text
https://docs.gitlab.com/<version>/ci/yaml/
https://docs.gitlab.com/<version>/api/rest/
```

GitLab releases a new minor version every month. The canonical supported-release list,
with release and end-of-life dates, is at
`https://docs.gitlab.com/ee/policy/maintenance.html`. Consult that page rather than
hard-coding versions here — the supported set shifts every month.

### Common Navigation Paths

**CI/CD Section (`/ci/`)**:

- `/ci/yaml/` — `.gitlab-ci.yml` syntax reference
- `/ci/variables/` — Predefined variables and custom variables
- `/ci/triggers/` — Pipeline triggers and API reference
- `/ci/merge_request_pipelines/` — MR pipelines and pipelines for merge requests
- `/ci/runners/` — Runner management and executor types
- `/ci/caching/` — Cache keys, dependency caching strategies
- `/ci/artifacts/` — Artifact retention, paths, reports
- `/ci/services/` — Service containers for jobs

**Runner Section (`/runner/`)**:

- `/runner/install/` — Installation guides (Docker, Kubernetes, Linux, macOS, Windows)
- `/runner/configuration/` — Configuration files and advanced options
- `/runner/executors/` — Executor types (Shell, Docker, Kubernetes, parallels, custom)
- `/runner/monitoring/` — Runner metrics and observability

**API Section (`/api/rest/`)**:

- `/api/rest/users.html` — Users API endpoints
- `/api/rest/projects.html` — Projects API endpoints
- `/api/rest/pipelines.html` — Pipelines API endpoints
- `/api/rest/jobs.html` — Jobs API endpoints
- GraphQL API: `https://docs.gitlab.com/graphql/` (separate GraphQL reference)

**User Section (`/user/`)**:

- `/user/project/` — Project features, settings
- `/user/group/` — Groups and subgroups
- `/user/issues/` — Issues and issue boards
- `/user/merge_requests/` — Merge requests, code review, approvals
- `/user/snippets/` — Code snippets management

### URL Structure Notes

- Trailing slashes matter: `/ci/yaml/` (with slash) vs `/ci/yaml` (without slash)
- API endpoints use `.html` suffix: `/api/rest/users.html`
- Search is available at `https://docs.gitlab.com/search/` but direct URLs are more reliable
- Enterprise Edition features are documented in the main docs with EE badges
