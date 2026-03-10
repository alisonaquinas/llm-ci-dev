# Jira Docs Site Navigation

## Structure Overview

Jira is a comprehensive work management platform with multiple product families. The documentation spans multiple
sites with distinct purposes and audiences.

## Jira Product Family

- **Jira Software**: Project and sprint management for software teams (Scrum and Kanban)
- **Jira Service Management**: IT service management and customer support ticketing
- **Jira Work Management**: General work and task management
- **Jira Align**: Portfolio and strategic planning
- **Jira Community**: User community forums

## Top-Level Documentation Sites

| Section | Base URL | Contents |
| --- | --- | --- |
| **Jira Cloud Support** | `https://support.atlassian.com/jira-software-cloud/` | Jira Software Cloud user documentation, board configuration, workflows, sprints, issues |
| **Jira Service Management** | `https://support.atlassian.com/jira-service-management/` | JSM-specific documentation: queues, service projects, SLA, automation |
| **REST API v3** | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/` | Official Jira REST API v3 reference, authentication, pagination, endpoints |
| **Board/Sprint API** | `https://developer.atlassian.com/cloud/jira/software/rest/` | Agile-specific REST endpoints: boards, sprints, backlog operations |
| **Cloud Automation** | `https://support.atlassian.com/cloud-automation/` | Jira Automation rules, triggers, conditions, actions, governance |
| **Marketplace** | `https://marketplace.atlassian.com/` | Third-party Jira Cloud apps and extensions |
| **Community Forums** | `https://community.atlassian.com/forums/jira` | User community discussion and peer support |

## Common Navigation Paths

### Jira Cloud Docs (`/jira-software-cloud/`)

- `/docs/` — Documentation index page
- `/docs/what-is-an-issue/` — Issue concepts and terminology
- `/docs/configure-your-board/` — Board settings and customization
- `/docs/sprint-management/` — Sprint planning and sprint board
- `/docs/create-and-edit-issues/` — Issue creation, editing, transitions
- `/docs/jira-automation-for-teams/` — Automation rules (team-managed)
- `/docs/what-is-a-workflow/` — Workflow concepts and status transitions
- `/docs/fields-and-custom-fields/` — Custom field configuration
- `/docs/jira-integrations/` — Bitbucket, Confluence, Slack integrations
- `/docs/jira-cloud-rest-api-migration-from-v2-to-v3/` — API v2 to v3 migration guide

### REST API Navigation (`/cloud/jira/platform/rest/v3/`)

- `/intro/` — API introduction and authentication
- `/issues/` — Issue operations (get, create, update, delete, transition)
- `/projects/` — Project operations
- `/workflows/` — Workflow and status operations
- `/fields/` — Field metadata and custom field operations
- `/users/` — User and group operations
- `/dashboards/` — Dashboard operations
- `/filters/` — Filter/saved search operations
- `/webhooks/` — Webhook configuration and triggers

## Cloud vs Data Center vs Server

Jira Cloud documentation is at `support.atlassian.com`. Jira Data Center and Server documentation may be
available at `confluence.atlassian.com/jira` (legacy hub), but Atlassian is sunsetting Server (end of life).
Always prefer Cloud documentation.

## URL Pattern Convention

Jira Cloud docs follow this pattern:

```text
https://support.atlassian.com/jira-software-cloud/docs/[topic-slug]/
```

Example: `https://support.atlassian.com/jira-software-cloud/docs/what-is-a-sprint/`

API docs follow:

```text
https://developer.atlassian.com/cloud/jira/platform/rest/v3/[resource]/[operation]/
```

Example: `https://developer.atlassian.com/cloud/jira/platform/rest/v3/issues/create-issue/`
