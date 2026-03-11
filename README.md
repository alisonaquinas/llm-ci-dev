# llm-ci-cd-skills

A collection of cross-compatible LLM agent skills for **CI/CD pipeline automation**, extending both
**Claude Code** and **Codex** with domain-specific knowledge for continuous integration and deployment workflows.

> **Status:** Active CI/CD skills collection. Sixty-one skills implemented: eight platform CI/CD workflow skills
> (GitLab, GitHub, Jenkins, Travis CI), four platform runner/agent management skills, four cloud/general CLI tools (Docker, AWS, Azure, GitLab CLI),
> four Infrastructure-as-Code skills (Terraform, OpenTofu, Pulumi, Ansible),
> four secret management skills (HashiCorp Vault, Bitwarden CLI, 1Password CLI, AWS Secrets Manager),
> ten package & build manager skills (npm, yarn, pnpm, pip, poetry, pipenv, maven, gradle, make, cmake),
> six version manager skills (nvm, rvm, rbenv, pyenv, asdf, direnv),
> seven Kubernetes tooling skills (kubectl, helm, kustomize, skaffold, tilt, flux, argocd),
> three container runtime skills (containerd, podman, cri-o),
> eight documentation lookup skills (platforms + Atlassian), one architecture knowledge skill, and two Docker-based utilities (YAML linting & LSP).
> All skills use the shared `SKILL.md` format, making them loadable by either agent without modification.

## Skills

### Platform CI/CD Workflow Skills

Write, maintain, and deploy CI/CD pipelines on major platforms.

| Skill | Status | Description |
| --- | --- | --- |
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
| --- | --- | --- |
| **gitlab-runner** | ✅ Implemented | Install and manage GitLab Runner daemons; installation, registration, executors, operations |
| **github-runner** | ✅ Implemented | Install and manage GitHub Actions self-hosted runners; installation, ARC, Kubernetes, operations |
| **jenkins-agent** | ✅ Implemented | Install and manage Jenkins agents and nodes; SSH/JNLP/Docker/Kubernetes, installation, operations |
| **travis-worker** | ✅ Implemented | Configure Travis CI SaaS environments and travis-worker daemon; installation, configuration, operations |

### Cloud & General CLI Tools

Essential command-line tools for CI/CD infrastructure and cloud deployments.

| Skill | Status | Description |
| --- | --- | --- |
| **docker** | ✅ Implemented | Build, run, and manage Docker containers; Dockerfile, images, registries, networking |
| **aws** | ✅ Implemented | AWS CLI for EC2, S3, CloudFormation, IAM, ECS, and other AWS service operations |
| **az** | ✅ Implemented | Azure CLI for resource groups, VMs, container registries, AKS, and Azure deployments |
| **glab** | ✅ Implemented | GitLab CLI for issues, merge requests, pipelines, and repository operations |

### Documentation Lookup Skills

Navigate platform-specific documentation online.

| Skill | Status | Description |
| --- | --- | --- |
| **gitlab-docs** | ✅ Implemented | Navigate docs.gitlab.com; URL patterns, CI/CD, runners, API, administration |
| **github-docs** | ✅ Implemented | Navigate docs.github.com/en; GitHub Actions, REST API, Packages, Security |
| **jenkins-docs** | ✅ Implemented | Navigate jenkins.io/doc; Declarative Pipeline, Shared Libraries, plugins, steps |
| **travis-ci-docs** | ✅ Implemented | Navigate docs.travis-ci.com; .travis.yml reference, build stages, deployment |

### Atlassian Documentation Lookup Skills

Navigate Atlassian cloud product documentation for issue tracking, command-line automation, and AI agents.

| Skill | Status | Description |
| --- | --- | --- |
| **jira-docs** | ✅ Implemented | Navigate Jira Cloud documentation and REST API v3; boards, workflows, JQL, automation |
| **jsm-docs** | ✅ Implemented | Navigate Jira Service Management Cloud documentation; queues, SLAs, portals, ITSM, Assets, REST API |
| **atlassian-cli-docs** | ✅ Implemented | Navigate Atlassian CLI (ACLI) documentation; installation, commands, CI integration |
| **rovo-docs** | ✅ Implemented | Navigate Atlassian Rovo documentation; Search, Chat, Agents, Rovo Dev CLI, administration |

### Package & Build Manager Skills

Install dependencies, manage package versions, and run builds across Node.js, Python, Java/JVM, and C/C++ ecosystems.

#### Node.js

| Skill | Status | Description |
| --- | --- | --- |
| **npm** | ✅ Implemented | Manage Node.js packages, run scripts, and audit dependencies with npm |
| **yarn** | ✅ Implemented | Manage JavaScript packages with Yarn Berry (v3/v4) or Classic (v1) |
| **pnpm** | ✅ Implemented | Manage Node.js packages efficiently with pnpm's content-addressable store |

#### Python

| Skill | Status | Description |
| --- | --- | --- |
| **pip** | ✅ Implemented | Install and manage Python packages with pip inside virtual environments |
| **poetry** | ✅ Implemented | Manage Python dependencies, virtual environments, and package builds with Poetry |
| **pipenv** | ✅ Implemented | Manage Python virtual environments and dependencies with Pipenv and Pipfile |

#### Java/JVM

| Skill | Status | Description |
| --- | --- | --- |
| **maven** | ✅ Implemented | Build and manage Java projects with Apache Maven lifecycle phases |
| **gradle** | ✅ Implemented | Build Java and Android projects with Gradle using the Gradle wrapper |

#### C/C++

| Skill | Status | Description |
| --- | --- | --- |
| **make** | ✅ Implemented | Automate builds and tasks with GNU Make and Makefiles |
| **cmake** | ✅ Implemented | Configure and build C/C++ projects with CMake using out-of-source builds |

### Secret Management Skills

Store, retrieve, and rotate secrets securely across HashiCorp Vault, Bitwarden, 1Password, and AWS.

| Skill | Status | Description |
| --- | --- | --- |
| **vault** | ✅ Implemented | Manage secrets, tokens, and policies with HashiCorp Vault KV engine and auth methods |
| **bitwarden-cli** | ✅ Implemented | Access and manage Bitwarden vault items via the bw CLI with session key auth |
| **1password-cli** | ✅ Implemented | Retrieve 1Password secrets and inject them into commands via op run and secret references |
| **aws-secretsmanager** | ✅ Implemented | Store, retrieve, and rotate secrets with AWS Secrets Manager via the AWS CLI |

### Version Manager Skills

Install, switch, and pin language runtime versions across Node.js, Ruby, and Python ecosystems.

| Skill | Status | Description |
| --- | --- | --- |
| **nvm** | ✅ Implemented | Manage multiple Node.js versions with nvm; install, switch, .nvmrc, shell integration |
| **rvm** | ✅ Implemented | Manage Ruby versions and gemsets with rvm; install, gemsets, .ruby-version autoswitch |
| **rbenv** | ✅ Implemented | Manage Ruby versions with rbenv and ruby-build; install, local/global/shell, .ruby-version |
| **pyenv** | ✅ Implemented | Manage multiple Python versions with pyenv; install, virtualenvs, .python-version |
| **asdf** | ✅ Implemented | Manage multiple language runtime versions with asdf; plugins, .tool-versions, CI usage |
| **direnv** | ✅ Implemented | Manage per-directory environment variables with direnv; .envrc, layouts, tool integrations |

### Infrastructure as Code (IaC) Skills

Provision and configure infrastructure declaratively.

| Skill | Status | Description |
| --- | --- | --- |
| **terraform** | ✅ Implemented | Plan and apply HashiCorp Terraform infrastructure; HCL, providers, state, workspaces |
| **open-tofu** | ✅ Implemented | Plan and apply OpenTofu (open-source Terraform fork); `tofu` CLI, native testing, state encryption, migration guide |
| **pulumi** | ✅ Implemented | Deploy cloud infrastructure with Pulumi using TypeScript, Python, Go, C#, or YAML; stacks, config, secrets |
| **ansible** | ✅ Implemented | Automate configuration management with Ansible; inventory, playbooks, roles, vault, galaxy |

### Kubernetes Tooling Skills

Deploy, configure, and develop with Kubernetes across the full lifecycle — from raw manifests to GitOps.

| Skill | Status | Description |
| --- | --- | --- |
| **kubectl** | ✅ Implemented | Manage Kubernetes resources, contexts, and workloads with kubectl |
| **helm** | ✅ Implemented | Package and deploy Kubernetes applications with Helm charts and releases |
| **kustomize** | ✅ Implemented | Customize Kubernetes manifests with overlay/base patterns and Kustomize |
| **skaffold** | ✅ Implemented | Build, push, and deploy to Kubernetes iteratively with Skaffold dev loops |
| **tilt** | ✅ Implemented | Develop Kubernetes services locally with Tilt and Tiltfile live-update |
| **flux** | ✅ Implemented | Manage GitOps Kubernetes deployments with FluxCD sources and Kustomizations |
| **argocd** | ✅ Implemented | Deploy Kubernetes apps declaratively with Argo CD applications and projects |

### Container Runtime Skills

Build and run containers with runtimes beyond Docker.

| Skill | Status | Description |
| --- | --- | --- |
| **containerd** | ✅ Implemented | Manage containers and images with containerd via ctr and nerdctl |
| **podman** | ✅ Implemented | Build and run rootless containers with Podman; pods, Quadlets, and systemd |
| **cri-o** | ✅ Implemented | Configure and debug CRI-O as a Kubernetes container runtime with crictl |

### Architecture & Best Practices

| Skill | Status | Description |
| --- | --- | --- |
| **ci-architecture** | ✅ Implemented | Design CI/CD pipelines using proven best practices (DORA, DevSecOps, SLSA, platform engineering) |

### Utility Skills

| Skill | Status | Description |
| --- | --- | --- |
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
