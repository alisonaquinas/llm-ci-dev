# Changelog

All notable changes to the llm-ci-cd-skills collection will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

#### Package & Build Manager Skills (10 new skills)

##### Node.js

- **npm** skill: Manage Node.js packages and run scripts with npm
  - 4 reference docs: install-and-setup.md, package-json.md, command-cookbook.md, workspaces.md
  - Content: nvm/fnm/corepack install, .npmrc config, package.json fields (dependencies/devDependencies/peerDependencies/exports/engines/scripts), init/install/ci/run/publish/update/outdated/audit/exec/link/pack commands, --dry-run for publish, workspaces field, --workspace flag, hoisting

- **yarn** skill: Manage JavaScript packages with Yarn Berry (v3/v4) and Classic (v1)
  - 4 reference docs: install-and-setup.md, configuration.md, command-cookbook.md, workspaces.md
  - Content: corepack enable, Classic vs Berry comparison, .yarnrc.yml (Berry) and .yarnrc (Classic), nodeLinker/PnP/node-modules, add/remove/install(--immutable)/run/dlx/up/audit/pack/publish/why/dedupe, workspaces foreach, workspace: protocol, constraints

- **pnpm** skill: Manage Node.js packages efficiently with pnpm's content-addressable store
  - 4 reference docs: install-and-setup.md, configuration.md, command-cookbook.md, workspaces.md
  - Content: corepack/standalone install, pnpm env for Node.js versions, .npmrc (shamefully-hoist/store-dir), pnpm-workspace.yaml, add/remove/install(--frozen-lockfile)/run/dlx/update/outdated/audit/publish/store prune, recursive (-r), --filter, workspace:/catalog: protocols

##### Python

- **pip** skill: Install and manage Python packages with pip inside virtual environments
  - 4 reference docs: install-and-setup.md, requirements-and-indexes.md, command-cookbook.md, virtual-environments.md
  - Content: ensurepip, pip upgrade, pip.conf/pip.ini, requirements.txt format, version specifiers, constraints files, --index-url/--extra-index-url, private PyPI, --require-hashes, install/download/uninstall/freeze/list/show/check/wheel/hash/cache purge, venv creation/activation (bash/fish/PowerShell), pipx for tools

- **poetry** skill: Manage Python dependencies, virtual environments, and package builds with Poetry
  - 4 reference docs: install-and-setup.md, pyproject-toml.md, command-cookbook.md, dependency-groups.md
  - Content: pipx install, POETRY_HOME, [tool.poetry] metadata, version constraints (^/~/*/>=), new/init/add/remove/install/update/show/build/publish/run/shell/env use/export/version commands, dependency groups (--with/--without/--only), group export to requirements.txt

- **pipenv** skill: Manage Python virtual environments and dependencies with Pipenv and Pipfile
  - 4 reference docs: install-and-setup.md, pipfile-and-lockfile.md, command-cookbook.md, environment-management.md
  - Content: pip user/brew install, PIPENV_VENV_IN_PROJECT, Pipfile [[source]]/[packages]/[dev-packages]/[requires], Pipfile.lock, install/uninstall/sync/lock/run/shell/graph/check/clean/update commands, .env auto-loading, PIPENV_PYTHON

##### Java/JVM

- **maven** skill: Build and manage Java projects with Apache Maven lifecycle phases
  - 4 reference docs: install-and-setup.md, pom-xml.md, command-cookbook.md, lifecycle-and-plugins.md
  - Content: brew/apt/sdkman install, Maven wrapper (mvnw), JAVA_HOME, settings.xml, GAV coordinates, dependency scopes, dependencyManagement, profiles, validate/compile/test/package/verify/install/deploy/clean/site phases, dependency:tree, versions plugin, -DskipTests/-B/-T/-pl/-am flags, surefire/failsafe/shade/compiler/resources plugins

- **gradle** skill: Build Java and Android projects with Gradle using the Gradle wrapper
  - 4 reference docs: install-and-setup.md, build-scripts.md, command-cookbook.md, tasks-and-plugins.md
  - Content: sdkman/brew install, Gradle wrapper (./gradlew), gradle init, Groovy vs Kotlin DSL, repositories/dependencies/configurations, settings.gradle, build/test/clean/assemble/check/run/dependencies/tasks commands, -m/--dry-run/--no-daemon/--parallel/--configuration-cache, java/application/spring-boot/maven-publish plugins

##### C/C++

- **make** skill: Automate builds and tasks with GNU Make and Makefiles
  - 4 reference docs: install-and-setup.md, makefile-syntax.md, command-cookbook.md, patterns-and-functions.md
  - Content: brew/apt/xcode-tools install, target/prerequisite/recipe structure (tab indentation), variable flavors (=/:=/?=/+=), automatic variables ($@/$</$^/$*), .PHONY/.DEFAULT_GOAL, make/-n/-j/-f/-C/-B/-k/V=1 flags, static pattern rules, wildcard/patsubst/shell/filter/foreach functions, ifeq/ifdef conditionals

- **cmake** skill: Configure and build C/C++ projects with CMake using out-of-source builds
  - 4 reference docs: install-and-setup.md, cmakelists.md, command-cookbook.md, build-types-and-generators.md
  - Content: brew/apt/pip/winget install, cmake_minimum_required/project()/add_executable/add_library/target_link_libraries/find_package/install(), cmake -S . -B build/-DCMAKE_BUILD_TYPE/--build/--install/ctest/--preset/-G flags, Debug/Release/RelWithDebInfo/MinSizeRel build types, single-config vs multi-config generators, toolchain files, CMakePresets.json

#### Infrastructure as Code Skills (4 new skills)

- **terraform** skill: Plan and apply HashiCorp Terraform infrastructure
  - 4 reference docs: install-and-setup.md, configuration.md, command-cookbook.md, state-and-backends.md
  - Content: macOS/Linux/Windows install, tfenv, provider blocks, variables, outputs, backends (S3/GCS/HCP), init/validate/fmt/plan/apply/destroy, state commands (list/show/mv/rm), import, workspaces, state locking, sensitive values

- **open-tofu** skill: Plan and apply OpenTofu (open-source Terraform fork) infrastructure
  - 4 reference docs: install-and-setup.md, configuration.md, command-cookbook.md, migrating-from-terraform.md
  - Content: installer script/apt/rpm/brew/winget install, tofuenv, HCL configuration (identical to Terraform), state encryption (OpenTofu-specific), `tofu test` native testing, provider lock, migration guide from Terraform (state compatibility, license comparison, CI/CD updates, rollback)

- **pulumi** skill: Deploy cloud infrastructure using TypeScript, Python, Go, C#, or YAML
  - 4 reference docs: install-and-setup.md, language-and-project.md, stacks-and-config.md, command-cookbook.md
  - Content: curl/brew/winget install, Pulumi Cloud and self-managed backends, language-specific code examples (TS/Python/Go/C#/YAML), Pulumi.yaml project file, stack operations, config/secrets management, cross-stack references, `pulumi new/preview/up/destroy/refresh/import/convert`

- **ansible** skill: Automate configuration management with agentless SSH automation
  - 4 reference docs: install-and-setup.md, inventory-and-variables.md, playbook-patterns.md, command-cookbook.md
  - Content: pip/apt/dnf/brew install, SSH key setup, ansible.cfg, INI/YAML inventory, group_vars/host_vars, dynamic inventory (AWS EC2/GCP), variable precedence, play structure, common modules table, conditionals/loops/register/tags/roles, ad-hoc commands, `ansible-playbook --check --diff`, ansible-galaxy, ansible-vault, ansible-inventory

#### Atlassian Documentation Lookup Skills (1 new skill)

- **jsm-docs** skill: Navigate Jira Service Management Cloud documentation at support.atlassian.com/jira-service-management and REST API
  - 4 reference docs: navigation.md, quick-reference.md, jsm-cloud-reference.md, api-reference.md
  - Content: JSM Cloud product overview, doc site structure, queue/SLA/portal/request type configuration, ITSM processes (incident/change/problem management), Assets (IT asset management), Knowledge Base integration, JSM REST API endpoints, authentication, pagination, asset management operations

## [0.0.1] - 2026-03-10

### Added

#### Platform CI/CD Workflow Skills (8 new skills)

- **gitlab-ci** skill: Write and maintain GitLab CI pipelines
  - 4 reference docs: pipeline-basics.md, runners-and-caching.md, testing-and-quality.md, variables-and-secrets.md
  - Content: `.gitlab-ci.yml` structure, job anatomy, stages, runners, caching, artifacts, testing, quality gates, variables, secrets, CI variables, OIDC tokens

- **gitlab-cd** skill: Deploy with GitLab CD environments and pipelines
  - 4 reference docs: environments-and-deployments.md, deployment-targets.md, review-apps.md, release-and-versioning.md
  - Content: Environment keyword, deployment tiers, protection rules, Kubernetes/AWS/GCP/Heroku deployments, review apps, releases, package registries

- **github-ci** skill: Write and maintain GitHub Actions CI workflows
  - 4 reference docs: workflow-basics.md, runners-and-caching.md, testing-patterns.md, security-and-secrets.md
  - Content: Workflow YAML, event triggers, job anatomy, GitHub-hosted/self-hosted runners, matrix testing, caching, testing, code coverage, secrets, permissions

- **github-cd** skill: Deploy with GitHub Actions CD workflows and OIDC
  - 4 reference docs: environments-and-protection.md, cloud-deployments.md, oidc-and-auth.md, releases-and-packages.md
  - Content: Environment protection, deployment approval, OIDC authentication, AWS/GCP/Azure/Kubernetes deployments, releases, container registries, artifact signing

- **jenkins-ci** skill: Write Jenkins Declarative Pipeline CI stages
  - 4 reference docs: declarative-pipeline.md, agents-and-workspaces.md, testing-and-reporting.md, shared-libraries.md
  - Content: Declarative Pipeline structure, agent types, stages, steps, post conditions, parameters, tools, when conditions, testing, reporting, shared libraries

- **jenkins-cd** skill: Deploy applications with Jenkins Pipeline stages
  - 4 reference docs: deployment-stages.md, credentials-and-secrets.md, deployment-targets.md, strategies-and-rollback.md
  - Content: Deployment stages, input approval, locking, credentials management, Kubernetes/AWS/Docker deployments, blue-green/canary strategies, rollback patterns

- **travis-ci** skill: Write and maintain Travis CI build configuration
  - 4 reference docs: build-lifecycle.md, matrix-and-environments.md, testing-patterns.md, caching-strategies.md
  - Content: Build phases, language matrix, OS variants, environment variables, conditional builds, testing, caching, Docker layer caching

- **travis-cd** skill: Deploy from Travis CI to cloud and registries
  - 4 reference docs: deployment-providers.md, deployment-conditions.md, credential-management.md, release-automation.md
  - Content: Deployment providers (Heroku, AWS S3, npm, PyPI, Docker, GitHub), conditional deployment, encrypted credentials, semantic versioning, releases

#### Platform Runner/Agent Management Skills (4 new skills)

- **gitlab-runner** skill: Install and manage GitLab Runner daemons
  - 4 reference docs: installation.md, registration-and-config.md, executors.md, operations.md
  - Content: Installation on Linux/Docker/Kubernetes/macOS/Windows, runner registration, auth tokens, config.toml anatomy, executor types (Shell, Docker, Kubernetes, SSH), health monitoring, log management, troubleshooting

- **github-runner** skill: Install and manage GitHub Actions self-hosted runners
  - 4 reference docs: installation.md, registration-and-config.md, arc-and-scaling.md, operations.md
  - Content: Runner installation on Linux/macOS/Windows/Docker, JNLP launch, registration tokens, runner labels/groups, Actions Runner Controller (ARC) on Kubernetes, ephemeral runners, auto-scaling, operations

- **jenkins-agent** skill: Install and manage Jenkins agents and nodes
  - 4 reference docs: agent-types.md, installation-and-connection.md, cloud-and-dynamic-agents.md, operations.md
  - Content: Agent types (SSH, JNLP, WebSocket JNLP, Docker Cloud, Kubernetes, built-in), agent.jar installation, SSH key setup, JNLP launch, Docker Cloud plugin, Kubernetes plugin with pod templates, CASC, operations

- **travis-worker** skill: Configure Travis CI SaaS environments and manage travis-worker daemon
  - 4 reference docs: saas-build-environments.md, enterprise-installation.md, enterprise-configuration.md, operations.md
  - Content: SaaS environment selection (OS, dist, arch), package/container installation, custom build images, RabbitMQ connection, pool sizing, resource limits, worker groups, enterprise configuration, monitoring

#### Platform Documentation Lookup Skills

- **gitlab-docs** skill: Navigate docs.gitlab.com for CI/CD, runners, API, administration docs via WebFetch
- **github-docs** skill: Navigate docs.github.com/en for Actions, REST API, Packages, Security docs via WebFetch
- **jenkins-docs** skill: Navigate jenkins.io/doc for Declarative Pipeline, Shared Libraries, plugins, steps via WebFetch
- **travis-ci-docs** skill: Navigate docs.travis-ci.com for .travis.yml reference, build stages, deployment via WebFetch

#### Atlassian Documentation Lookup Skills (3 new skills)

- **jira-docs** skill: Navigate Jira Cloud documentation at support.atlassian.com/jira-software-cloud and REST API v3
  - 4 reference docs: navigation.md, quick-reference.md, jira-cloud-reference.md, api-reference.md
  - Content: Jira Cloud product family overview, doc site structure, board/sprint/workflow/issue configuration, JQL syntax, REST API v3 endpoints, authentication, pagination, rate limiting

- **atlassian-cli-docs** skill: Navigate Atlassian CLI (ACLI) documentation at developer.atlassian.com/cloud/acli
  - 4 reference docs: navigation.md, quick-reference.md, command-reference.md, ci-integration.md
  - Content: ACLI guides, installation, command tree (admin, jira, rovodev subcommands), CI pipeline integration patterns, output formatting, command chaining

- **rovo-docs** skill: Navigate Atlassian Rovo documentation at support.atlassian.com/rovo
  - 4 reference docs: navigation.md, quick-reference.md, rovo-dev-reference.md, agents-and-governance.md
  - Content: Rovo Search/Chat/Agents features, Rovo Dev CLI commands, MCP server integration, IDE support (VS Code, Cursor), agent creation and governance, org administration

#### Architecture & Best Practices

- **ci-architecture** skill: Design CI/CD pipelines using proven best practices (DORA metrics, DevSecOps, SLSA framework, platform engineering patterns)
  - 4 reference docs: pipeline-design.md, security-practices.md, deployment-patterns.md, measurement.md
  - Content: Canonical pipeline stages, test pyramid, branching strategies, artifact management, deployment patterns (blue-green, canary, rolling, GitOps, IaC), security practices, DORA metrics, observability, incident recovery

#### Cloud & General CLI Tools (4 skills migrated from llm-shared-skills)

- **docker** skill: Build, run, and manage Docker containers and images
  - 10 reference files + scripts and assets
  - Content: Dockerfile authoring, image building, container lifecycle, networking, volumes, Docker Compose, registry operations, multi-stage builds, security best practices
  - Cross-platform coverage: Linux, macOS, Windows, WSL2

- **aws** skill: AWS CLI for cloud infrastructure operations
  - 5 reference files + scripts
  - Content: EC2, S3, CloudFormation, IAM, ECS, deployment patterns, credential management
  - Cross-platform coverage: Linux, macOS, Windows, WSL2

- **az** skill: Azure CLI for Azure resource management
  - 5 reference files + scripts
  - Content: Resource groups, VMs, container registries, AKS, app service deployments
  - Cross-platform coverage: Linux, macOS, Windows, WSL2

- **glab** skill: GitLab CLI for repository and pipeline operations
  - 5 reference files + scripts
  - Content: Issues, merge requests, pipelines, variables, CI/CD operations, authentication

### Previously Added

- yaml-linting skill: Docker-based YAML linting with yamllint (pipelinecomponents/yamllint)
- yaml-lsp skill: YAML Language Server in Docker for editor integration (node:lts-alpine + npm)
- Initial plugin scaffold for CI/CD skills collection
- Repository structure and documentation templates
- Installation guides for Claude Code and Codex
- AGENTS.md guidance for skill development
- Linting system imported from llm-shared-skills with 12 validation rules (L01-L12)
- Markdownlint configuration aligned with skill standards

### Planned

- Docker / Container Registry skills
- Kubernetes / Helm deployment skills
- Monitoring and alerting skills (Prometheus, Grafana, etc.)
- Custom CI/CD patterns and anti-patterns

---

## [0.1.0] - 2026-03-10

### Added

- Initial repository setup with plugin scaffolding
- Configuration files for Claude Code and Codex integration
- Documentation framework for skills
