# JSM Docs Site Navigation

## Structure Overview

Jira Service Management (JSM) is Atlassian's IT service management platform distinct from Jira Software.
The documentation spans multiple sites with distinct purposes and audiences: service desk admins, IT teams, developers,
and customers using the portal.

## JSM vs Jira Software

- **Jira Software**: Project and sprint management for software development teams (Scrum and Kanban boards)
- **Jira Service Management**: IT service management, customer support ticketing, incident/change management, ITSM processes

JSM has its own project types, service desk concepts (queues, SLAs, customer portals), and ITSM-focused workflows.
While both use the Jira REST API, JSM adds service desk-specific endpoints.

## Top-Level Documentation Sites

| Section | Base URL | Contents |
| --- | --- | --- |
| **JSM Cloud Support** | `https://support.atlassian.com/jira-service-management/` | JSM Cloud user documentation, queues, SLAs, portals, requests, ITSM processes |
| **JSM Docs Index** | `https://support.atlassian.com/jira-service-management/docs/` | Complete JSM documentation index |
| **JSM REST API** | `https://developer.atlassian.com/cloud/jira/service-desk/rest/` | Official JSM REST API reference, authentication, pagination, endpoints |
| **Developer Hub** | `https://developer.atlassian.com/cloud/jira/service-desk/` | JSM Forge apps, Connect integrations, webhooks, CLI |
| **Cloud Automation** | `https://support.atlassian.com/cloud-automation/` | Automation rules (shared with Jira Software), triggers, conditions, actions |
| **Community Forums** | `https://community.atlassian.com/forums/jira-service-management` | User community discussion and peer support |

## Common Navigation Paths

### JSM Cloud Docs (`/jira-service-management/`)

- `/docs/` — Documentation index page
- `/docs/what-is-a-service-project/` — Service project overview and terminology
- `/docs/create-a-service-project/` — Service project creation and setup
- `/docs/create-a-queue/` — Queue creation and management
- `/docs/configure-sla-goals/` — SLA goal configuration and tracking
- `/docs/set-up-a-customer-portal/` — Customer portal setup and customization
- `/docs/create-and-edit-request-types/` — Request type creation and field configuration
- `/docs/configure-request-forms/` — Request form building and conditional fields
- `/docs/incident-management/` — Incident management ITSM process
- `/docs/change-management/` — Change management ITSM process
- `/docs/problem-management/` — Problem management ITSM process
- `/docs/what-is-assets/` — Assets (IT asset management) overview and configuration
- `/docs/jira-service-management-automation/` — JSM automation rules and governance

### REST API Navigation (`/cloud/jira/service-desk/rest/`)

- `/api-group-service-desks/` — Service desk operations
- `/api-group-customers/` — Customer management
- `/api-group-requests/` — Request CRUD operations
- `/api-group-request-types/` — Request type metadata
- `/api-group-queues/` — Queue operations
- `/api-group-slas/` — SLA metrics and query
- `/api-group-organizations/` — Organization management
- `/api-group-portal/` — Customer portal operations
- `/api-group-knowledgebase/` — Knowledge base search
- `/api-group-assets/` (Insight) — Asset management operations

## JSM Cloud vs Data Center

JSM Cloud documentation is at `support.atlassian.com/jira-service-management`. JSM Data Center documentation may be
available at `confluence.atlassian.com/servicemanagement` (legacy hub). Always prefer Cloud documentation when available.

## URL Pattern Convention

JSM Cloud docs follow this pattern:

```text
https://support.atlassian.com/jira-service-management/docs/[topic-slug]/
```

Example: `https://support.atlassian.com/jira-service-management/docs/create-a-queue/`

API docs follow:

```text
https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-[group]/
```

Example: `https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-requests/`
