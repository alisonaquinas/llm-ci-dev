# GitHub Docs Site Navigation

## Structure Overview

docs.github.com is organized into major product sections. The base URL is `https://docs.github.com/en` with language variants.

### Top-Level Sections

| Section | Base URL | Contents |
| --- | --- | --- |
| **Actions** | `https://docs.github.com/en/actions` | Workflows, triggers, jobs, expressions, contexts, reusable workflows, OIDC, security |
| **Packages** | `https://docs.github.com/en/packages` | Publishing packages, container registry, npm/Maven/NuGet/RubyGems/Python |
| **Security** | `https://docs.github.com/en/security` | Dependabot, code scanning, secret scanning, vulnerability alerts |
| **REST API** | `https://docs.github.com/en/rest` | REST API reference, authentication, pagination, endpoints |
| **GraphQL API** | `https://docs.github.com/en/graphql` | GraphQL API schema, queries, mutations, explorer |
| **Repositories** | `https://docs.github.com/en/repositories` | Repository management, branching, merging, permissions |
| **Issues & PRs** | `https://docs.github.com/en/issues` | Creating and managing issues, pull requests, discussions |
| **Codespaces** | `https://docs.github.com/en/codespaces` | Development containers, setup, configuration |

### GitHub Enterprise Support

For GitHub Enterprise Server (GHES), replace `/en` with `/en/enterprise-server@x.x`:

```text
https://docs.github.com/en/enterprise-server@3.10/actions/
https://docs.github.com/en/enterprise-server@3.9/rest/
```

Current supported GHES versions: 3.10, 3.9, 3.8, 3.7

### Common Navigation Paths

**Actions Section (`/actions/`)**:

- `/actions/writing-workflows/` — Workflow creation and configuration
- `/actions/using-workflows/` — Reusable workflows and workflow templates
- `/actions/writing-workflows/workflow-syntax-for-github-actions` — Full syntax reference
- `/actions/using-workflows/workflow-events-that-trigger-workflows` — Trigger events (push, pull_request, schedule, etc.)
- `/actions/learn-github-actions/` — Tutorials and learning resources
- `/actions/managing-workflow-runs/` — Run management and logs
- `/actions/security-for-github-actions/` — Security guides and hardening
- `/actions/using-github-cli-in-workflows/` — GitHub CLI usage in workflows

**REST API Section (`/rest/`)**:

- `/rest/reference/actions` — Actions API endpoints
- `/rest/reference/repos` — Repository endpoints
- `/rest/reference/pulls` — Pull request endpoints
- `/rest/reference/issues` — Issues endpoints
- `/rest/guides/` — API guides and best practices
- `/rest/overview/` — Authentication, rate limiting, pagination

**Repository Management (`/repositories/`)**:

- `/repositories/creating-and-managing-repositories/` — Repository creation
- `/repositories/configuring-branches-and-merges-in-your-repository/` — Branch protection rules
- `/repositories/managing-your-repositorys-settings-and-features/` — Repository settings
- `/repositories/releasing-projects-on-github/` — Releases and tags

**Security (`/security/`)**:

- `/security/dependabot/` — Dependency updates and alerts
- `/security/code-scanning/` — Code scanning with CodeQL
- `/security/secret-scanning/` — Secret scanning and alerts
- `/security/guides/` — Security best practices

### URL Structure Notes

- Trailing slashes matter in most cases (use consistent formatting)
- Language variants use `/en`, `/es`, `/fr`, `/ja`, `/pt`, `/zh` prefixes
- Search is available at `https://docs.github.com/search` but direct URLs are more reliable
- Product documentation uses clear hierarchy: `/en/<product>/<section>/<page>`
