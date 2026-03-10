# Jira REST API v3 Reference

The Jira REST API v3 is the current standard for programmatic access to Jira Cloud.

## Base URLs and Versioning

| API | Base URL | Status |
| --- | --- | --- |
| REST API v3 (current) | `https://api.atlassian.com/site/[site-id]/rest/api/3/` | Current / Recommended |
| REST API v2 (legacy) | `https://[your-domain].atlassian.net/rest/api/2/` | Legacy / Deprecated |
| Board API | `https://api.atlassian.com/site/[site-id]/rest/agile/1.0/` | Current for Scrum/Kanban |
| Filter API | `https://api.atlassian.com/site/[site-id]/rest/api/3/` | Included in v3 |

## Authentication Methods

| Method | Details | URL |
| --- | --- | --- |
| OAuth 2.0 (3LO) | Three-legged OAuth, user-facing auth | `https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/` |
| Basic Auth | Email + API token | `https://developer.atlassian.com/cloud/jira/platform/basic-auth-for-rest-apis/` |
| JWT / Service Account | App authentication (Forge, Connect) | `https://developer.atlassian.com/cloud/jira/platform/connect/authentication-for-connect-apps/` |
| Personal Access Token | For Atlassian CLI and integrations | `https://developer.atlassian.com/cloud/jira/platform/basic-auth-for-rest-apis/` |

## API Namespaces

| Namespace | Purpose | URL |
| --- | --- | --- |
| Issues | Issue CRUD, transitions, search | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/issues/` |
| Projects | Project metadata and operations | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/projects/` |
| Workflows | Workflow and status management | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/workflows/` |
| Screens & Fields | Field definitions and screen configuration | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/screens/` |
| Users & Groups | User and group operations | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/users/` |
| Dashboards | Dashboard operations | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/dashboards/` |
| Filters | Saved filters and search operations | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/filters/` |
| Webhooks | Webhook configuration and management | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/webhooks/` |
| Configuration | Global configuration operations | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/configurations/` |
| Permissions | Permission checking | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/permissions/` |

## JQL Reference

| Component | Purpose | URL |
| --- | --- | --- |
| JQL syntax | Query language reference | `https://support.atlassian.com/jira-software-cloud/docs/jira-query-language-jql-syntax/` |
| JQL functions | Built-in query functions | `https://support.atlassian.com/jira-software-cloud/docs/jql-functions/` |
| JQL operators | Comparison and logical operators | `https://support.atlassian.com/jira-software-cloud/docs/advanced-issue-search/` |
| JQL fields | Searchable field names | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/issues/search-issues-jql/` |

## Pagination and Filtering

| Parameter | Details |
| --- | --- |
| `startAt` | Zero-indexed starting position (default: 0) |
| `maxResults` | Number of results to return (default: 50, max: 100) |
| `nextPage` | Cursor-based pagination when available |
| `expand` | Fields to include in response (comma-separated) |
| `fields` | Specific fields to return (comma-separated) |

## Rate Limiting

- **Rate limit**: 10 requests per second per user
- **Burst allowance**: 20 requests per minute
- Headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- Reference: `https://developer.atlassian.com/cloud/jira/platform/rate-limits/`

## Notable Resources

| Resource | URL |
| --- | --- |
| API v2 to v3 migration guide | `https://support.atlassian.com/jira-software-cloud/docs/jira-cloud-rest-api-migration-from-v2-to-v3/` |
| API changelog | `https://developer.atlassian.com/cloud/jira/platform/changelog/` |
| Forge platform | `https://developer.atlassian.com/cloud/jira/platform/forge/` |
| REST API introduction | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/` |
| Issue search endpoint | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/issues/search-issues-jql/` |
| Create issue endpoint | `https://developer.atlassian.com/cloud/jira/platform/rest/v3/issues/create-issue/` |
