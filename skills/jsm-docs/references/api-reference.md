# JSM REST API Reference

Official Jira Service Management REST API documentation for programmatic service desk operations.

## Base URLs

| API | Base URL | Version |
| --- | --- | --- |
| JSM REST API | `https://developer.atlassian.com/cloud/jira/service-desk/rest/` | v3 |
| Assets REST API | `https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-assets/` | 1.0 |
| Jira Core REST API (shared) | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/` | v3 |

JSM REST API operates at the service desk level and complements Jira Core REST API for platform-level operations.

## Authentication Methods

| Method | Details | Documentation |
| --- | --- | --- |
| OAuth 2.0 3LO | Third-party app authorization via OAuth consent screen | `https://developer.atlassian.com/cloud/jira/service-desk/rest/intro/#authentication` |
| Basic Auth | Email + API token for direct API calls | `https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/` |
| JWT/Connect | Forge apps and Connect integrations using JWT | `https://developer.atlassian.com/cloud/jira/service-desk/understand-jira-service-desk-apis/` |

## API Namespaces

| Namespace | Purpose | Base Endpoint |
| --- | --- | --- |
| **servicedesk** | List and retrieve service desks | `/rest/servicedeskapi/servicedesk` |
| **customer** | Add/remove/retrieve customers | `/rest/servicedeskapi/customer` |
| **organization** | Manage organizations and membership | `/rest/servicedeskapi/organization` |
| **portal** | Customer portal groups and article lookup | `/rest/servicedeskapi/portal` |
| **queue** | List queues and retrieve queue issues | `/rest/servicedeskapi/queue` |
| **request** | Create, get, update, comment on requests | `/rest/servicedeskapi/request` |
| **requesttype** | List request types and field schemas | `/rest/servicedeskapi/requesttype` |
| **sla** | Retrieve SLA metrics for requests | `/rest/servicedeskapi/sla` |
| **knowledgebase** | Search KB articles linked to service desk | `/rest/servicedeskapi/knowledgebase` |
| **insight** | Assets object schemas and objects | `/rest/assets/1.0` |

## Key Endpoints (Common Operations)

| Operation | URL |
| --- | --- |
| List service desks | `GET /rest/servicedeskapi/servicedesk` |
| Get service desk by key | `GET /rest/servicedeskapi/servicedesk/{serviceDeskId}` |
| Create customer request | `POST /rest/servicedeskapi/request` |
| Get request | `GET /rest/servicedeskapi/request/{issueIdOrKey}` |
| Update request | `PUT /rest/servicedeskapi/request/{issueIdOrKey}` |
| Add comment to request | `POST /rest/servicedeskapi/request/{issueIdOrKey}/comment` |
| List request types | `GET /rest/servicedeskapi/requesttype?serviceDeskId={id}` |
| List queues | `GET /rest/servicedeskapi/queue?serviceDeskId={id}` |
| Get SLA info for request | `GET /rest/servicedeskapi/request/{issueIdOrKey}/sla` |
| Search KB articles | `GET /rest/servicedeskapi/knowledgebase/articles?serviceDeskId={id}` |

## Pagination

JSM REST API uses limit/start pagination pattern:

```text
GET /rest/servicedeskapi/queue?serviceDeskId=1&start=0&limit=50
```

Response includes:

- `values` — Array of items on this page
- `start` — Starting position (0-indexed)
- `limit` — Items per page
- `isLastPage` — Boolean indicating if more pages exist
- `size` — Number of items on this page

## Notable References

- **API Changelog**: `https://developer.atlassian.com/cloud/jira/service-desk/changelog/`
- **Forge for JSM**: `https://developer.atlassian.com/cloud/jira/service-desk/build-jira-service-management-apps/`
- **JSM OAuth Scopes**: `https://developer.atlassian.com/cloud/jira/service-desk/oauth-2-3lo-scope-reference/`
- **Webhooks for JSM**: `https://developer.atlassian.com/cloud/jira/service-desk/webhooks/`
