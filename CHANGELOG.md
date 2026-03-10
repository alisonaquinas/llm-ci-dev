# Changelog

All notable changes to the llm-ci-cd-skills collection will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

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
