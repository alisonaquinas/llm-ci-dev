---
name: jsm-docs
description: >
  Look up Jira Service Management Cloud documentation at support.atlassian.com/jira-service-management
  and the JSM REST API at developer.atlassian.com/cloud/jira/service-desk/rest using WebFetch.
  Covers site navigation, URL patterns, queues, SLAs, customer portals, ITSM processes,
  Assets, and the full JSM REST API reference.
---

# Jira Service Management Docs Lookup

Navigate and fetch documentation from support.atlassian.com/jira-service-management and developer.atlassian.com/cloud/jira/service-desk/rest
to answer questions about Jira Service Management Cloud queues, SLAs, customer portals, ITSM processes, Assets, and the REST API.
This skill encodes the JSM docs structure so the agent can construct direct links and retrieve relevant documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Site Navigation | `references/navigation.md` | Understanding the JSM docs site structure and finding the right section |
| Quick Reference | `references/quick-reference.md` | Looking up the most frequently needed JSM configuration and admin pages |
| JSM Cloud Reference | `references/jsm-cloud-reference.md` | Configuring queues, SLAs, portals, request types, ITSM processes, Assets |
| API Reference | `references/api-reference.md` | Using the JSM REST API for programmatic service desk operations |

---

## Quick Start

### Key URL Patterns

The JSM documentation is organized around these top-level sections:

- **JSM Cloud Support**: `https://support.atlassian.com/jira-service-management/`
- **JSM Docs Index**: `https://support.atlassian.com/jira-service-management/docs/`
- **JSM REST API**: `https://developer.atlassian.com/cloud/jira/service-desk/rest/`
- **Assets documentation**: `https://support.atlassian.com/jira-service-management/docs/what-is-assets/`
- **Cloud Automation (JSM)**: `https://support.atlassian.com/cloud-automation/resources/`
- **JSM Community**: `https://community.atlassian.com/forums/jira-service-management`
- **Atlassian Developer (JSM)**: `https://developer.atlassian.com/cloud/jira/service-desk/`

### How to Look Up Documentation

1. Identify the topic (queues, SLAs, portals, request types, ITSM processes, API, Assets)
2. Start with the appropriate section URL from above
3. Use WebFetch to load the page and extract relevant details
4. When the specific page is unknown, load the quick-reference to find the most common pages
5. For REST API lookups, use the api-reference to find endpoint paths and parameters

### Common WebFetch Patterns

```text
Use WebFetch on https://support.atlassian.com/jira-service-management/docs/ to browse all JSM docs
Use WebFetch on https://support.atlassian.com/jira-service-management/docs/configure-sla-goals/ to look up SLA configuration
Use WebFetch on https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-requests/ to find JSM REST API reference
Use WebFetch on https://support.atlassian.com/jira-service-management/docs/set-up-a-customer-portal/ for customer portal setup
```

---

## Related References

- Load **Site Navigation** to understand the JSM docs site structure and product capabilities
- Load **Quick Reference** for the top 20+ most frequently needed documentation pages
- Load **JSM Cloud Reference** for complete queue, SLA, portal, request type, ITSM process, and Assets configuration
- Load **API Reference** for REST API endpoints, authentication methods, and programmatic JSM operations
