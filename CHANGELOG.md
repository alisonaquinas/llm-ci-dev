# Changelog

All notable changes to the llm-ci-cd-skills collection will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

#### Documentation & Architecture Skills

- **gitlab-docs** skill: Navigate docs.gitlab.com for CI/CD, runners, API, administration docs via WebFetch
- **github-docs** skill: Navigate docs.github.com/en for Actions, REST API, Packages, Security docs via WebFetch
- **jenkins-docs** skill: Navigate jenkins.io/doc for Declarative Pipeline, Shared Libraries, plugins, steps via WebFetch
- **travis-ci-docs** skill: Navigate docs.travis-ci.com for .travis.yml reference, build stages, deployment via WebFetch
- **ci-architecture** skill: Design CI/CD pipelines using proven best practices (DORA metrics, DevSecOps, SLSA framework, platform engineering patterns)
  - 4 reference docs: pipeline-design.md, security-practices.md, deployment-patterns.md, measurement.md
  - Content: Canonical pipeline stages, test pyramid, branching strategies, artifact management, deployment patterns (blue-green, canary, rolling, GitOps, IaC), security practices, DORA metrics, observability, incident recovery

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
- Terraform / Infrastructure-as-Code skills
- Monitoring and alerting skills (Prometheus, Grafana, etc.)
- Custom CI/CD patterns and anti-patterns

---

## [0.1.0] - 2026-03-10

### Added

- Initial repository setup with plugin scaffolding
- Configuration files for Claude Code and Codex integration
- Documentation framework for skills
