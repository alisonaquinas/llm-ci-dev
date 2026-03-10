# Agents & Workspaces — Agent Types, Docker Setup, and Cross-Stage File Sharing

## Overview

Jenkins agents are the machines where pipeline jobs execute. Declarative Pipeline supports multiple agent types: `any`, `label`, `docker`, `dockerfile`, and `kubernetes`. Each agent type provides different isolation, performance, and resource-management characteristics. This reference covers agent configuration, workspace management, file sharing between stages, and concurrent build handling.

---

## Agent Types

### Agent `any`

Use the first available agent in the pool with no constraints:

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh 'echo Running on: $(hostname)'
      }
    }
  }
}
```

**Use case:** Simple pipelines with no specific tool or OS requirements.

---

### Agent `label`

Run on agents matching one or more labels (Linux/macOS/Windows tags):

```groovy
pipeline {
  agent { label 'linux && docker && !slow' }

  stages {
    stage('Build') {
      steps {
        sh 'uname -a'
      }
    }
  }
}
```

**Label expressions:**

- `label 'linux'` — Single label
- `label 'linux && docker'` — Both labels required
- `label 'linux || macos'` — Either label
- `label 'linux && !slow'` — Linux but not slow

**Use case:** Target specific agent pools by capability (e.g., Docker-capable agents, GPU nodes, production-only agents).

---

### Agent `node`

Equivalent to `label` but allows custom workspace specification:

```groovy
pipeline {
  agent {
    node {
      label 'linux'
      customWorkspace '/var/jenkins/custom/${BUILD_NUMBER}'
    }
  }

  stages {
    stage('Build') {
      steps {
        sh 'pwd'  // Outputs custom workspace path
      }
    }
  }
}
```

**Use case:** When you need full control over workspace location (e.g., avoiding disk space issues, using specific mount points).

---

### Agent `docker`

Run stages in a Docker container on an agent with Docker installed:

```groovy
pipeline {
  agent any

  stages {
    stage('Build Java') {
      agent { docker 'openjdk:11-jdk' }
      steps {
        sh 'javac --version'
        sh 'java --version'
      }
    }

    stage('Build Node') {
      agent { docker 'node:16-alpine' }
      steps {
        sh 'node --version'
        sh 'npm --version'
      }
    }
  }
}
```

### Docker Agent Options

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      agent {
        docker {
          image 'maven:3.8.1-openjdk-11'
          label 'docker'                    // Run on agents with 'docker' label
          args '-v /root/.m2:/root/.m2'     // Mount volumes
          registryUrl 'https://registry.example.com'
          registryCredentialsId 'docker-creds'
          reuseNode true                    // Reuse parent agent workspace
        }
      }
      steps {
        sh 'mvn --version'
      }
    }
  }
}
```

### Docker Key Options

| Option | Purpose |
| --- | --- |
| `image` | Docker image to run (required) |
| `label` | Agent label (run on labeled agents only) |
| `args` | Additional Docker run arguments (-v, -e, etc.) |
| `registryUrl` | Private registry URL |
| `registryCredentialsId` | Jenkins credentials for registry login |
| `reuseNode` | Share workspace with parent agent |
| `alwaysPull` | Always pull latest image |

**Use case:** Isolate build tools, ensure consistent environments, run different tool versions without local installation.

---

### Agent `dockerfile`

Build and run a Dockerfile inline within the pipeline:

```groovy
pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile.build'           // Use specific Dockerfile
      label 'docker'                        // Run on docker-capable agents
      args '-v /root/.m2:/root/.m2 -e CI=true'
      additionalBuildArgs '--build-arg JAVA_VERSION=11'
    }
  }

  stages {
    stage('Build') {
      steps {
        sh 'java --version'
      }
    }
  }
}
```

### Dockerfile Example

```dockerfile
# Dockerfile.build
FROM maven:3.8.1-openjdk-11

RUN apt-get update && apt-get install -y \
  git \
  curl \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
```

**Use case:** Complex build environments defined as code, version-controlled Dockerfiles that evolve with project needs.

---

### Agent `kubernetes`

Run pipeline in Kubernetes pods (requires Kubernetes plugin):

```groovy
pipeline {
  agent {
    kubernetes {
      label 'ci-build'
      cloud 'kubernetes'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: agent
spec:
  containers:
  - name: maven
    image: maven:3.8.1-openjdk-11
    command: ['cat']
    tty: true
  - name: docker
    image: docker:20.10
    command: ['cat']
    tty: true
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-socket
    hostPath:
      path: /var/run/docker.sock
"""
    }
  }

  stages {
    stage('Build') {
      steps {
        container('maven') {
          sh 'mvn --version'
        }
      }
    }
    stage('Containerize') {
      steps {
        container('docker') {
          sh 'docker --version'
        }
      }
    }
  }
}
```

**Use case:** Cloud-native CI/CD, auto-scaling agent pools, ephemeral build environments.

---

## Workspace Management

### Default Workspace

By default, Jenkins creates a workspace per job on each agent:

```bash
$JENKINS_HOME/workspace/<job-name>/
```

Access the workspace path via `${WORKSPACE}`:

```groovy
steps {
  sh 'echo $WORKSPACE'
  sh 'ls -la $WORKSPACE'
}
```

### Custom Workspace

Override the default workspace location:

```groovy
pipeline {
  agent {
    node {
      label 'linux'
      customWorkspace '/mnt/fast-ssd/${JOB_NAME}/${BUILD_NUMBER}'
    }
  }

  stages {
    stage('Build') {
      steps {
        sh 'pwd'  // Outputs custom path
      }
    }
  }
}
```

**Use case:** Use faster disks, avoid concurrent build conflicts, organize workspaces by project.

### Workspace Cleanup

Clean up workspace before or after builds:

```groovy
pipeline {
  agent any

  options {
    skipDefaultCheckout()  // Don't auto-checkout SCM
  }

  stages {
    stage('Clean') {
      steps {
        deleteDir()  // Delete entire workspace
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'make build'
      }
    }
  }

  post {
    always {
      deleteDir()  // Clean after build completes
    }
  }
}
```

---

## Stash and Unstash — Cross-Stage File Sharing

### Problem

By default, multiple stages run on different agents or in different Docker containers. Files created in one stage are not automatically available to another stage.

### Solution: Stash and Unstash

Use `stash` to save files before switching contexts, and `unstash` to retrieve them:

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      agent { docker 'maven:3.8.1-openjdk-11' }
      steps {
        checkout scm
        sh 'mvn clean package'
        stash name: 'app', includes: 'target/*.jar'  // Save JAR
      }
    }

    stage('Test') {
      agent { docker 'openjdk:11-jdk' }
      steps {
        unstash 'app'  // Retrieve JAR
        sh 'java -jar target/app.jar --test'
      }
    }

    stage('Deploy') {
      agent { label 'deployment' }
      steps {
        unstash 'app'  // Retrieve JAR again
        sh './deploy.sh target/app.jar'
      }
    }
  }
}
```

### Stash/Unstash Syntax

```groovy
// Stash files
stash name: 'name',
      includes: 'pattern1,pattern2',
      excludes: 'exclude-pattern'

// Unstash files
unstash 'name'

// Allow unstash to fail gracefully
try {
  unstash 'name'
} catch (error) {
  echo 'Stash not found, skipping'
}
```

### Stash Examples

```groovy
// Stash build artifacts
stash name: 'build', includes: 'target/**'

// Stash with exclusions
stash name: 'source',
      includes: 'src/**',
      excludes: 'src/**/*.class'

// Stash test reports
stash name: 'reports', includes: '**/test-results/**'

// Stash entire workspace
stash name: 'workspace', includes: '**'
```

**Use case:** Share artifacts between stages running on different agents, avoid re-building in each stage.

---

## Concurrent Builds

### Enable/Disable Concurrency

By default, Jenkins allows multiple builds of the same job to run concurrently. Control this with `disableConcurrentBuilds()`:

```groovy
pipeline {
  agent any

  options {
    disableConcurrentBuilds()  // Only one build at a time
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

### Managing Concurrent Builds with Workspaces

If concurrent builds are enabled, use unique workspace paths:

```groovy
pipeline {
  agent {
    node {
      label 'linux'
      customWorkspace '/mnt/builds/${JOB_NAME}-${BUILD_NUMBER}'  // Unique per build
    }
  }

  stages {
    stage('Build') {
      steps {
        sh 'pwd'  // Each build has its own path
      }
    }
  }
}
```

### Concurrent Parallel Testing

Run test suites in parallel to speed up feedback:

```groovy
pipeline {
  agent any

  options {
    disableConcurrentBuilds(abortPrevious: false)  // Cancel previous builds if needed
  }

  stages {
    stage('Build') {
      steps {
        sh 'make build'
      }
    }

    stage('Test') {
      parallel {
        stage('Unit') {
          steps {
            sh 'make test-unit'
          }
        }
        stage('Integration') {
          steps {
            sh 'make test-integration'
          }
        }
        stage('Smoke') {
          steps {
            sh 'make test-smoke'
          }
        }
      }
    }
  }
}
```

---

## Complete Example: Multi-Agent Pipeline with Stash

```groovy
pipeline {
  agent none  // No default agent

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  stages {
    stage('Compile') {
      agent { label 'linux' }
      steps {
        checkout scm
        sh 'mvn clean compile'
        stash name: 'source', includes: 'src/**,target/classes/**'
      }
    }

    stage('Unit Tests') {
      agent { docker 'maven:3.8.1-openjdk-11' }
      steps {
        unstash 'source'
        sh 'mvn test'
        stash name: 'test-results', includes: 'target/surefire-reports/**'
      }
    }

    stage('Build Image') {
      agent { label 'docker' }
      steps {
        unstash 'source'
        sh 'docker build -t myapp:${BUILD_NUMBER} .'
        sh 'docker save myapp:${BUILD_NUMBER} > /tmp/image.tar'
        stash name: 'image', includes: '/tmp/image.tar'
      }
    }

    stage('Deploy to Dev') {
      agent { label 'dev-deployer' }
      steps {
        unstash 'image'
        sh 'docker load < /tmp/image.tar'
        sh './deploy-dev.sh myapp:${BUILD_NUMBER}'
      }
    }

    stage('Deploy to Prod') {
      agent { label 'prod-deployer' }
      steps {
        unstash 'image'
        input 'Deploy to production?'
        sh 'docker load < /tmp/image.tar'
        sh './deploy-prod.sh myapp:${BUILD_NUMBER}'
      }
    }
  }

  post {
    always {
      unstash 'test-results'
      junit 'target/surefire-reports/**/*.xml'
    }
    failure {
      echo 'Pipeline failed'
    }
  }
}
```

---
