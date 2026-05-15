# GitLab Duo & AI Features

Index of GitLab's AI-driven product surfaces on docs.gitlab.com. The agent should
WebFetch the canonical pages below rather than guessing structure — each entry maps a
named feature to the exact URL that documents its current GA status, configuration,
and admin controls.

## GitLab Duo (Core)

| Feature | Documentation URL |
| --- | --- |
| Duo overview | `https://docs.gitlab.com/user/gitlab_duo/` |
| Duo Code Suggestions (inline completion) | `https://docs.gitlab.com/user/project/repository/code_suggestions/` |
| Duo Chat (in-IDE and Web Chat) | `https://docs.gitlab.com/user/gitlab_duo_chat/` |
| Duo Workflow (test generation, refactor) | `https://docs.gitlab.com/user/gitlab_duo/use_cases/` |
| Duo turn-on / disable controls (admin) | `https://docs.gitlab.com/administration/gitlab_duo/` |
| Duo data privacy and zero-data-retention | `https://docs.gitlab.com/user/gitlab_duo/data_usage/` |

## Duo Agent Platform

| Feature | Documentation URL |
| --- | --- |
| Duo Agent Platform overview | `https://docs.gitlab.com/user/duo_agent_platform/` |
| Planner agent (issue/spec decomposition) | `https://docs.gitlab.com/user/duo_agent_platform/agents/` |
| Security Analyst agent | `https://docs.gitlab.com/user/duo_agent_platform/agents/` |
| Data Analyst agent | `https://docs.gitlab.com/user/duo_agent_platform/agents/` |
| Authoring custom agents | `https://docs.gitlab.com/user/duo_agent_platform/custom_agents/` |
| Agent invocation from CI/CD | `https://docs.gitlab.com/user/duo_agent_platform/ci_cd_integration/` |

## Code Review & Merge Request AI

| Feature | Documentation URL |
| --- | --- |
| Duo Code Review (auto-suggested comments) | `https://docs.gitlab.com/user/project/merge_requests/duo_code_review/` |
| Summarize merge request changes | `https://docs.gitlab.com/user/project/merge_requests/duo_in_merge_requests/` |
| Summarize merge request comments / review threads | `https://docs.gitlab.com/user/project/merge_requests/duo_in_merge_requests/#summarize-merge-request-comments` |
| Generate commit messages | `https://docs.gitlab.com/user/project/merge_requests/duo_in_merge_requests/#generate-a-commit-message` |
| Generate merge request descriptions | `https://docs.gitlab.com/user/project/merge_requests/duo_in_merge_requests/#fill-in-merge-request-descriptions` |

## SDLC Analytics & Governance

| Feature | Documentation URL |
| --- | --- |
| AI Impact / SDLC trends dashboard | `https://docs.gitlab.com/user/analytics/ai_impact_analytics/` |
| Duo seat assignment and usage | `https://docs.gitlab.com/subscriptions/subscription-add-ons/` |
| Duo audit events | `https://docs.gitlab.com/administration/audit_event_streaming/` |
| Self-hosted models for Duo (custom LLM endpoint) | `https://docs.gitlab.com/administration/gitlab_duo_self_hosted/` |

## IDE & Surface Integrations

| Surface | Documentation URL |
| --- | --- |
| VS Code (GitLab Workflow extension) | `https://docs.gitlab.com/editor_extensions/visual_studio_code/` |
| JetBrains (GitLab plugin) | `https://docs.gitlab.com/editor_extensions/jetbrains_ide/` |
| Visual Studio | `https://docs.gitlab.com/editor_extensions/visual_studio/` |
| Neovim | `https://docs.gitlab.com/editor_extensions/neovim/` |
| Web IDE Duo features | `https://docs.gitlab.com/user/project/web_ide/` |

## Notes

- GitLab Duo is a paid add-on; admin must enable it per group/instance. See `https://docs.gitlab.com/subscriptions/subscription-add-ons/` for licensing.
- Duo Agent Platform was promoted to GA in the 18.x release line; the agent catalog continues to expand each monthly release. Always check the docs for current agent inventory rather than caching agent names here.
- Self-hosted GitLab can route Duo traffic to a customer-managed model endpoint via `https://docs.gitlab.com/administration/gitlab_duo_self_hosted/`.
