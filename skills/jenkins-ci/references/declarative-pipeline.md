# Declarative Pipeline — Pipeline Block Structure and Keywords

## Overview

Jenkins Declarative Pipeline is a simplified, opinionated syntax for defining continuous integration workflows. All pipelines must be wrapped in a `pipeline { }` block and contain required elements: `agent` and `stages`. Declarative Pipeline provides a constrained, readable alternative to Scripted Pipeline for most CI/CD use cases.

---

## Pipeline Block Structure

### Top-Level Syntax

Every Declarative Pipeline follows this structure:

```groovy
pipeline {
  agent { ... }                    // Required: where to run
  options { ... }                  // Optional: pipeline-level settings
  parameters { ... }               // Optional: input parameters
  environment { ... }              // Optional: global environment variables
  tools { ... }                    // Optional: install/manage tools
  triggers { ... }                 // Optional: automatic triggers
  stages { ... }                   // Required: pipeline stages
  post { ... }                     // Optional: post-build actions
}
```

---

## Agent Directive

The `agent` directive specifies where pipeline stages execute. It is required at the pipeline level and can be overridden at the stage level.

### Agent Types

#### `agent any`

Execute on any available agent (no constraints):

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh 'make build'
      }
    }
  }
}
```

#### `agent { label 'selector' }`

Execute on agents matching one or more labels:

```groovy
pipeline {
  agent { label 'linux && !docker' }

  stages {
    stage('Build') {
      steps {
        sh 'gcc --version'
      }
    }
  }
}
```

#### `agent { node { label 'selector' } }`

Similar to label, but also allows `customWorkspace`:

```groovy
pipeline {
  agent {
    node {
      label 'linux'
      customWorkspace '/var/jenkins_home/custom-workspace'
    }
  }

  stages {
    stage('Build') {
      steps {
        sh 'pwd'
      }
    }
  }
}
```

#### `agent none`

No default agent; each stage must specify its own:

```groovy
pipeline {
  agent none

  stages {
    stage('Build') {
      agent { label 'linux' }
      steps {
        sh 'make build'
      }
    }
    stage('Test') {
      agent { label 'windows' }
      steps {
        bat 'make test'
      }
    }
  }
}
```

---

## Stages Block

### Stage Organization

The `stages` block contains one or more `stage()` blocks. Stages execute sequentially unless `parallel` is used.

```groovy
pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build') {
      steps {
        sh 'make build'
      }
    }
    stage('Test') {
      steps {
        sh 'make test'
      }
    }
  }
}
```

### Stage-Level Agent Override

Override the pipeline agent for a specific stage:

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      agent { docker 'openjdk:11' }
      steps {
        sh 'javac --version'
      }
    }
    stage('Deploy') {
      agent { label 'production' }
      steps {
        sh './deploy.sh'
      }
    }
  }
}
```

### Stage-Level Options

Apply settings to a single stage:

```groovy
pipeline {
  agent any

  stages {
    stage('Long-Running Build') {
      options {
        timeout(time: 1, unit: 'HOURS')
        retry(2)
      }
      steps {
        sh 'make long-build'
      }
    }
  }
}
```

### Stage-Level Environment

Define variables for a single stage:

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      environment {
        BUILD_ENV = 'production'
        DEBUG = 'false'
      }
      steps {
        sh 'echo $BUILD_ENV'
      }
    }
  }
}
```

---

## Steps Block

The `steps` block contains one or more commands or step types. Steps execute sequentially.

### Common Step Types

#### `sh` — Execute shell command (Linux/macOS)

```groovy
steps {
  sh 'npm install'
  sh 'npm run build'
}
```

#### `bat` — Execute batch command (Windows)

```groovy
steps {
  bat 'npm install'
  bat 'npm run build'
}
```

#### `script` — Execute arbitrary Groovy code

```groovy
steps {
  script {
    if (env.BRANCH_NAME == 'main') {
      sh './deploy-production.sh'
    } else {
      sh './deploy-staging.sh'
    }
  }
}
```

#### `echo` — Print message

```groovy
steps {
  echo 'Starting build...'
}
```

#### Other Common Steps

- `checkout scm` — Checkout source code from Git/Mercurial
- `junit 'test-results.xml'` — Parse JUnit XML test results
- `archiveArtifacts 'build/**'` — Archive build artifacts
- `publishHTML target: [reportDir: 'coverage', reportFiles: 'index.html', reportName: 'Coverage']` — Publish HTML reports
- `input 'Do you want to proceed?'` — Wait for user input

---

## Post Block

The `post` block defines actions to run after stages complete, regardless of success/failure.

### Post Conditions

```groovy
pipeline {
  agent any

  stages {
    stage('Test') {
      steps {
        sh 'make test'
      }
    }
  }

  post {
    always {
      echo 'This always runs'
      junit 'test-results.xml'
    }
    success {
      echo 'Pipeline succeeded'
      archiveArtifacts 'build/**'
    }
    failure {
      echo 'Pipeline failed'
      emailext(
        subject: 'Build Failed: ${JOB_NAME}',
        body: '${BUILD_LOG_EXCERPT}',
        to: 'team@example.com'
      )
    }
    unstable {
      echo 'Pipeline is unstable'
    }
    changed {
      echo 'Status changed since last run'
    }
  }
}
```

### Post Conditions Explained

| Condition | When It Runs |
| --- | --- |
| `always` | Always, regardless of pipeline result |
| `success` | Only if pipeline succeeds |
| `failure` | Only if pipeline fails |
| `unstable` | Only if pipeline is unstable (test failures) |
| `aborted` | Only if pipeline is aborted |
| `changed` | Only if pipeline status changed from previous run |
| `cleanup` | Runs after all post conditions (Jenkins 2.121+) |

---

## Environment Directive

Define environment variables at pipeline or stage level.

### Pipeline-Level Environment

```groovy
pipeline {
  agent any

  environment {
    BUILD_NUMBER = "${BUILD_NUMBER}"
    GIT_COMMIT = "${GIT_COMMIT}"
    REGISTRY = 'docker.io'
    IMAGE_NAME = "${REGISTRY}/myapp"
  }

  stages {
    stage('Build') {
      steps {
        sh 'echo Building ${IMAGE_NAME}:${BUILD_NUMBER}'
      }
    }
  }
}
```

### Stage-Level Environment

```groovy
stages {
  stage('Build') {
    environment {
      NODE_ENV = 'production'
    }
    steps {
      sh 'npm install && npm run build'
    }
  }
}
```

### Built-In Jenkins Variables

- `${BUILD_NUMBER}` — Build number (e.g., 123)
- `${BUILD_ID}` — Build ID (timestamp-based)
- `${JOB_NAME}` — Job name
- `${BRANCH_NAME}` — Git branch (requires Git plugin)
- `${GIT_COMMIT}` — Full Git commit hash
- `${GIT_BRANCH}` — Git branch name
- `${WORKSPACE}` — Jenkins workspace directory
- `${JENKINS_HOME}` — Jenkins installation directory

---

## Parameters Directive

Declare input parameters for manual or API-triggered builds.

### Parameter Types

```groovy
pipeline {
  agent any

  parameters {
    string(
      name: 'VERSION',
      defaultValue: '1.0.0',
      description: 'Release version'
    )
    choice(
      name: 'ENV',
      choices: ['dev', 'staging', 'production'],
      description: 'Deployment environment'
    )
    booleanParam(
      name: 'SKIP_TESTS',
      defaultValue: false,
      description: 'Skip running tests'
    )
    text(
      name: 'DEPLOY_NOTES',
      defaultValue: '',
      description: 'Deployment notes'
    )
  }

  stages {
    stage('Build') {
      steps {
        echo "Building version ${params.VERSION}"
      }
    }
  }
}
```

### Using Parameters in Pipeline

```groovy
pipeline {
  agent any

  parameters {
    string(name: 'BRANCH', defaultValue: 'main')
  }

  stages {
    stage('Checkout') {
      steps {
        sh "git checkout ${params.BRANCH}"
      }
    }
  }
}
```

---

## Options Directive

Set pipeline-level execution options and behavior.

```groovy
pipeline {
  agent any

  options {
    // Keep last 10 builds
    buildDiscarder(logRotator(numToKeepStr: '10'))

    // Pipeline times out after 1 hour
    timeout(time: 1, unit: 'HOURS')

    // Disable concurrent builds
    disableConcurrentBuilds()

    // Retry failed builds 2 times
    retry(2)

    // Add timestamps to console output
    timestamps()

    // Set custom workspace
    skipDefaultCheckout()
  }

  stages {
    stage('Build') {
      steps {
        sh 'make build'
      }
    }
  }
}
```

### Common Options

| Option | Purpose |
| --- | --- |
| `buildDiscarder(logRotator(...))` | Discard old builds and logs |
| `timeout(time: N, unit: 'HOURS')` | Timeout pipeline execution |
| `disableConcurrentBuilds()` | Only one build at a time |
| `timestamps()` | Add timestamps to console output |
| `skipDefaultCheckout()` | Skip automatic Git checkout |
| `retry(N)` | Retry entire pipeline N times on failure |

---

## Tools Directive

Automatically install and make tools available in the pipeline.

```groovy
pipeline {
  agent any

  tools {
    maven 'Maven 3.8.1'
    nodejs 'Node.js 16'
    jdk 'OpenJDK 11'
  }

  stages {
    stage('Build') {
      steps {
        sh 'mvn clean install'
      }
    }
  }
}
```

---

## When Directive

Conditionally execute a stage based on expressions.

### When Expressions

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      when {
        branch 'main'
      }
      steps {
        sh 'make build'
      }
    }

    stage('Deploy') {
      when {
        branch 'main'
        expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
      }
      steps {
        sh './deploy.sh'
      }
    }

    stage('Conditional') {
      when {
        environment name: 'BRANCH_NAME', value: 'main'
      }
      steps {
        sh 'echo On main branch'
      }
    }
  }
}
```

### When Conditions

| Condition | Meaning |
| --- | --- |
| `branch 'main'` | Run if current branch is 'main' |
| `expression { ... }` | Run if Groovy expression evaluates to true |
| `environment { name: 'VAR', value: 'VALUE' }` | Run if environment variable matches |
| `changeset '*.java'` | Run if Java files changed |
| `triggeredBy 'GitPushCause'` | Run if triggered by specific cause |

---

## Input Directive

Pause pipeline and wait for user input before proceeding.

### Input Step

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh 'make build'
      }
    }

    stage('Deploy to Production') {
      steps {
        input 'Deploy to production?'
        sh './deploy-prod.sh'
      }
    }
  }
}
```

### Input with Approval

```groovy
stages {
  stage('Approval') {
    steps {
      input(
        id: 'deploy-approval',
        message: 'Deploy to production?',
        ok: 'Deploy',
        submitter: 'ops-team',
        submitterParameter: 'approved_by'
      )
    }
  }
}
```

---

## Parallel Execution

Execute stages or steps in parallel to reduce total pipeline time.

### Parallel Stages

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh 'make build'
      }
    }

    stage('Test Parallel') {
      parallel {
        stage('Unit Tests') {
          steps {
            sh 'make test-unit'
          }
        }
        stage('Integration Tests') {
          steps {
            sh 'make test-integration'
          }
        }
        stage('Smoke Tests') {
          steps {
            sh 'make test-smoke'
          }
        }
      }
    }

    stage('Deploy') {
      steps {
        sh 'make deploy'
      }
    }
  }
}
```

### Parallel Steps

```groovy
stages {
  stage('Deploy') {
    parallel {
      stage('Deploy to US') {
        agent { label 'us-region' }
        steps {
          sh './deploy us'
        }
      }
      stage('Deploy to EU') {
        agent { label 'eu-region' }
        steps {
          sh './deploy eu'
        }
      }
    }
  }
}
```

---

## Triggers Directive

Automatically trigger pipeline builds on events.

```groovy
pipeline {
  agent any

  triggers {
    // Trigger on Git push
    githubPush()

    // Trigger on GitLab push
    gitlabPush()

    // Trigger periodically (cron schedule)
    cron('H H * * 0')  // Weekly on Sunday

    // Poll repository for changes
    pollSCM('H/15 * * * *')  // Every 15 minutes

    // Trigger on upstream job completion
    upstream(upstreamProjects: 'upstream-job', threshold: hudson.model.Result.SUCCESS)
  }

  stages {
    stage('Build') {
      steps {
        sh 'make build'
      }
    }
  }
}
```

---

## Complete Example: Multi-Stage Pipeline

```groovy
pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 30, unit: 'MINUTES')
    timestamps()
  }

  parameters {
    string(name: 'VERSION', defaultValue: '1.0.0', description: 'Release version')
    choice(name: 'ENV', choices: ['dev', 'staging', 'prod'], description: 'Target environment')
  }

  environment {
    REGISTRY = 'docker.io'
    IMAGE_NAME = "${REGISTRY}/myapp"
    BUILD_TAG = "${BUILD_NUMBER}-${GIT_COMMIT.take(7)}"
  }

  tools {
    maven 'Maven 3.8.1'
    jdk 'OpenJDK 11'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package -DskipTests'
      }
    }

    stage('Test') {
      parallel {
        stage('Unit Tests') {
          steps {
            sh 'mvn test'
          }
        }
        stage('Integration Tests') {
          steps {
            sh 'mvn verify'
          }
        }
      }
    }

    stage('Build Image') {
      when {
        branch 'main'
      }
      steps {
        sh 'docker build -t ${IMAGE_NAME}:${BUILD_TAG} .'
      }
    }

    stage('Approval') {
      when {
        branch 'main'
      }
      steps {
        input 'Deploy to production?'
      }
    }

    stage('Deploy') {
      when {
        branch 'main'
      }
      agent { label 'deployment' }
      steps {
        sh './deploy.sh ${IMAGE_NAME}:${BUILD_TAG} ${params.ENV}'
      }
    }
  }

  post {
    always {
      junit 'target/surefire-reports/**/*.xml'
      publishHTML(target: [reportDir: 'target/site', reportFiles: 'index.html', reportName: 'Coverage'])
    }
    success {
      echo 'Pipeline succeeded'
      archiveArtifacts 'target/*.jar'
    }
    failure {
      echo 'Pipeline failed'
      emailext(
        subject: 'Build Failed: ${JOB_NAME}',
        body: '${BUILD_LOG_EXCERPT}',
        to: 'team@example.com'
      )
    }
  }
}
```

---
