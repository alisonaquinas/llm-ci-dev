---
name: jira-docs
description: >
  Look up Jira Software Cloud documentation at support.atlassian.com/jira-software-cloud
  and the Jira REST API v3 at developer.atlassian.com/cloud/jira using WebFetch.
  Teaches site navigation, URL patterns, board and workflow configuration, JQL syntax,
  and the full REST API v3 reference.
---

# Jira Docs Lookup

Navigate and fetch documentation from support.atlassian.com/jira-software-cloud and developer.atlassian.com/cloud/jira
to answer questions about Jira Cloud boards, workflows, issues, sprints, projects, and the REST API v3.
This skill encodes the Jira docs structure so the agent can construct direct links and retrieve relevant documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Site Navigation | `references/navigation.md` | Understanding the Jira docs site structure and finding the right section |
| Quick Reference | `references/quick-reference.md` | Looking up the most frequently needed Jira configuration and admin pages |
| Jira Cloud Reference | `references/jira-cloud-reference.md` | Configuring Jira Cloud boards, workflows, sprints, issues, and integrations |
| API Reference | `references/api-reference.md` | Using the Jira REST API v3 and JQL for programmatic access |

---

## Quick Start

### Key URL Patterns

The Jira documentation is organized around these top-level sections:

- **Jira Cloud Support**: `https://support.atlassian.com/jira-software-cloud/`
- **Jira Service Management**: `https://support.atlassian.com/jira-service-management/`
- **REST API v3**: `https://developer.atlassian.com/cloud/jira/platform/rest/v3/`
- **Board/Sprint API**: `https://developer.atlassian.com/cloud/jira/software/rest/`
- **Cloud Automation**: `https://support.atlassian.com/cloud-automation/`
- **Jira Marketplace**: `https://marketplace.atlassian.com/`
- **Jira Community**: `https://community.atlassian.com/forums/jira`

### How to Look Up Documentation

1. Identify the topic (boards, workflows, issues, API, automation, integration)
2. Start with the appropriate section URL from above
3. Use WebFetch to load the page and extract relevant details
4. When the specific page is unknown, load the quick-reference to find the most common pages
5. For REST API lookups, use the API reference to find endpoint paths and parameters

### Common WebFetch Patterns

```text
Use WebFetch on https://support.atlassian.com/jira-software-cloud/docs/ to browse all Cloud docs
Use WebFetch on https://developer.atlassian.com/cloud/jira/platform/rest/v3/ to look up REST API endpoints
Use WebFetch on https://support.atlassian.com/cloud-automation/resources/ to find automation rules
Use WebFetch on https://support.atlassian.com/jira-software-cloud/docs/what-is-an-issue/ for issue concepts
```

---

## Related References

- Load **Site Navigation** to understand the Jira docs site structure and product family
- Load **Quick Reference** for the top 20+ most frequently needed documentation pages
- Load **Jira Cloud Reference** for complete board, workflow, issue, sprint, and integration configuration
- Load **API Reference** for REST API v3 endpoints, JQL syntax, and authentication methods
