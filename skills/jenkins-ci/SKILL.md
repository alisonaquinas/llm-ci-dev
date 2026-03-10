---
name: jenkins-ci
description: >
  Write Jenkins Declarative Pipeline CI stages.
  Design and maintain CI pipelines using Jenkins Declarative Pipeline syntax with agents, stages, testing, and post-build actions.
---

# Jenkins CI

Write and maintain Jenkins Declarative Pipeline CI stages with confidence. This skill covers pipeline block structure, agent configuration, multi-stage execution, testing patterns, and post-build actions for continuous integration pipelines on Jenkins.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Declarative Pipeline | `references/declarative-pipeline.md` | Learning pipeline block, agent directive, stages, steps, post conditions, environment, parameters, options, tools, when, input, and parallel execution |
| Agents & Workspaces | `references/agents-and-workspaces.md` | Configuring agents (any, label, docker, dockerfile, kubernetes), workspace management, stash/unstash, concurrent builds |
| Testing & Reporting | `references/testing-and-reporting.md` | JUnit reports, archiveArtifacts, code coverage (JaCoCo/Cobertura), HTML publishing, SonarQube, static analysis, test trends, notifications |
| Shared Libraries | `references/shared-libraries.md` | Library structure (vars/, src/, resources/), @Library annotation, call() method pattern, loading strategies, step reuse, and testing |

---

## Quick Start

### Basic Jenkins Declarative Pipeline

1. **Create Jenkinsfile** — Save as `Jenkinsfile` in repository root or specify in Jenkins UI
2. **Define pipeline block** — Wrap entire pipeline definition in `pipeline { }`
3. **Specify agent** — Use `agent any` (any available agent) or `agent { label 'linux' }`
4. **Add stages** — Organize work into `stages { stage('name') { steps { } } }`
5. **Add steps** — Execute commands with `sh`, `bat`, or other step types

### Minimal Declarative Pipeline

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        echo 'Building application...'
        sh 'make build'
      }
    }
    stage('Test') {
      steps {
        echo 'Running tests...'
        sh 'make test'
      }
    }
  }

  post {
    always {
      junit 'test-results.xml'
    }
    failure {
      echo 'Pipeline failed!'
    }
  }
}
```

### Pipeline Anatomy

```groovy
pipeline
├── agent: Where to run (any, label, docker, kubernetes)
├── options: Pipeline-level settings (timeout, buildDiscarder, retry)
├── parameters: Input parameters (string, choice, booleanParam)
├── environment: Global environment variables
├── tools: Tool availability (maven, gradle, nodejs)
└── stages:
    └── stage('name'):
        ├── agent: Override pipeline agent (optional)
        ├── environment: Stage-level variables
        ├── options: Stage-level settings
        ├── when: Conditional execution
        ├── steps: Sequential commands
        └── post: Always/Success/Failure actions
```

### File Location

The `Jenkinsfile` must be at the repository root. Jenkins automatically detects and executes it on webhook events. Alternatively, create `Jenkinsfile` in subdirectories and reference the path in Jenkins pipeline job configuration.

### Note on File Format

Jenkins Declarative Pipelines use **Groovy syntax**, not YAML. For validating YAML configuration files used alongside Jenkins (e.g., Kubernetes, Helm, Docker Compose), use the `yaml-linting` or `yaml-lsp` skills.

---

## Related Skills

- **yaml-linting** — Validate YAML syntax for Kubernetes/Helm configs used in Jenkins pipelines
- **yaml-lsp** — Enable YAML editor support for configuration files
- **ci-architecture** — Plan multi-stage CI/CD pipeline strategies
- **jenkins-docs** — Reference official Jenkins documentation

---
