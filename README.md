# llm-ci-cd-skills

A collection of cross-compatible LLM agent skills for **CI/CD pipeline automation**, extending both
**Claude Code** and **Codex** with domain-specific knowledge for continuous integration and deployment workflows.

> **Status:** Active CI/CD skills collection. Twenty-three skills implemented: eight platform CI/CD workflow skills
> (GitLab, GitHub, Jenkins, Travis CI), four platform runner/agent management skills, four cloud/general CLI tools (Docker, AWS, Azure, GitLab CLI),
> four documentation lookup skills, one architecture knowledge skill, and two Docker-based utilities (YAML linting & LSP).
> All skills use the shared `SKILL.md` format, making them loadable by either agent without modification.

## Skills

### Platform CI/CD Workflow Skills

Write, maintain, and deploy CI/CD pipelines on major platforms.

| Skill | Status | Description |
|---|---|---|
| **gitlab-ci** | ✅ Implemented | Write and maintain GitLab CI pipelines; `.gitlab-ci.yml`, jobs, stages, runners, caching, artifacts |
| **gitlab-cd** | ✅ Implemented | Deploy with GitLab CD environments and pipelines; deployments, environments, review apps, releases |
| **github-ci** | ✅ Implemented | Write and maintain GitHub Actions CI workflows; workflow YAML, jobs, runners, testing, caching |
| **github-cd** | ✅ Implemented | Deploy with GitHub Actions CD workflows and OIDC; environments, OIDC authentication, cloud deployments |
| **jenkins-ci** | ✅ Implemented | Write Jenkins Declarative Pipeline CI stages; Jenkinsfile, agents, stages, testing, shared libraries |
| **jenkins-cd** | ✅ Implemented | Deploy applications with Jenkins Pipeline stages; deployments, credentials, strategies, rollback |
| **travis-ci** | ✅ Implemented | Write and maintain Travis CI build configuration; `.travis.yml`, phases, matrix, caching, environment |
| **travis-cd** | ✅ Implemented | Deploy from Travis CI to cloud and registries; providers, conditions, credentials, release automation |

### Platform Runner/Agent Management Skills

Install, configure, and operate CI runners and agents on self-hosted infrastructure.

| Skill | Status | Description |
|---|---|---|
| **gitlab-runner** | ✅ Implemented | Install and manage GitLab Runner daemons; installation, registration, executors, operations |
| **github-runner** | ✅ Implemented | Install and manage GitHub Actions self-hosted runners; installation, ARC, Kubernetes, operations |
| **jenkins-agent** | ✅ Implemented | Install and manage Jenkins agents and nodes; SSH/JNLP/Docker/Kubernetes, installation, operations |
| **travis-worker** | ✅ Implemented | Configure Travis CI SaaS environments and travis-worker daemon; installation, configuration, operations |

### Cloud & General CLI Tools

Essential command-line tools for CI/CD infrastructure and cloud deployments.

| Skill | Status | Description |
|---|---|---|
| **docker** | ✅ Implemented | Build, run, and manage Docker containers; Dockerfile, images, registries, networking |
| **aws** | ✅ Implemented | AWS CLI for EC2, S3, CloudFormation, IAM, ECS, and other AWS service operations |
| **az** | ✅ Implemented | Azure CLI for resource groups, VMs, container registries, AKS, and Azure deployments |
| **glab** | ✅ Implemented | GitLab CLI for issues, merge requests, pipelines, and repository operations |

### Documentation Lookup Skills

Navigate platform-specific documentation online.

| Skill | Status | Description |
|---|---|---|
| **gitlab-docs** | ✅ Implemented | Navigate docs.gitlab.com; URL patterns, CI/CD, runners, API, administration |
| **github-docs** | ✅ Implemented | Navigate docs.github.com/en; GitHub Actions, REST API, Packages, Security |
| **jenkins-docs** | ✅ Implemented | Navigate jenkins.io/doc; Declarative Pipeline, Shared Libraries, plugins, steps |
| **travis-ci-docs** | ✅ Implemented | Navigate docs.travis-ci.com; .travis.yml reference, build stages, deployment |

### Architecture & Best Practices

| Skill | Status | Description |
|---|---|---|
| **ci-architecture** | ✅ Implemented | Design CI/CD pipelines using proven best practices (DORA, DevSecOps, SLSA, platform engineering) |

### Utility Skills

| Skill | Status | Description |
|---|---|---|
| **yaml-linting** | ✅ Implemented | Docker-based YAML linting with yamllint (pipelinecomponents/yamllint) |
| **yaml-lsp** | ✅ Implemented | YAML Language Server via Docker for editor integration (node:lts-alpine + npx) |

## Quick Start

See [INSTALL.md](INSTALL.md) for full installation instructions.

**Claude Code (as local plugin):**

```json
// In ~/.claude/settings.json, add to enabledPlugins:
"llm-ci-cd-skills@local": true
```

Then point Claude Code at this directory as a local plugin source.

## Repository Structure

```text
llm-ci-cd-skills/
├── .claude-plugin/
│   └── plugin.json                  # Claude Code plugin registration
├── skills/                          # One subdirectory per skill (empty for now)
├── AGENTS.md                        # Guidance for AI agents working in this repo
├── CHANGELOG.md                     # Release history
├── INSTALL.md                       # Installation instructions
├── LICENSE.md                       # MIT
└── README.md                        # This file
```

## Adding Skills

To add a new CI/CD skill:

1. Create `skills/<name>/` with the exact skill name in kebab-case
2. Write `SKILL.md` with valid YAML frontmatter (`name` and `description`)
3. Create `agents/openai.yaml` with `display_name`, `short_description`, and `default_prompt`
4. Add reference documentation in `references/` and scripts in `scripts/` as needed
5. Update the skill table in this README

For detailed guidance, see [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE.md)
