# Deployment Stages

Patterns for organizing Jenkins Pipeline stages, approval gates, resource locking, and promotion workflows.

## Deployment Stage Organization

### Basic Multi-Environment Pattern

```groovy
pipeline {
  agent any
  stages {
    stage('Deploy to Dev') {
      steps {
        sh 'kubectl apply -f dev-deployment.yaml'
      }
    }
    stage('Deploy to Staging') {
      steps {
        sh 'kubectl apply -f staging-deployment.yaml'
      }
    }
    stage('Deploy to Production') {
      steps {
        sh 'kubectl apply -f prod-deployment.yaml'
      }
    }
  }
}
```

### Sequential vs. Parallel Stages

```groovy
pipeline {
  agent any
  stages {
    stage('Build & Test') {
      steps {
        sh 'mvn clean package'
      }
    }
    stage('Parallel Deployments') {
      parallel {
        stage('Deploy to East') {
          steps {
            sh 'kubectl apply -f deployment.yaml --context=us-east-1'
          }
        }
        stage('Deploy to West') {
          steps {
            sh 'kubectl apply -f deployment.yaml --context=us-west-1'
          }
        }
      }
    }
  }
}
```

## Input Step for Manual Approval

The `input` step pauses a pipeline and waits for human approval.

### Basic Approval

```groovy
stage('Approve Production Deployment') {
  steps {
    input message: 'Deploy to production?', ok: 'Deploy'
  }
}
```

### Approval with Role Restriction

```groovy
stage('Approve Production Deployment') {
  steps {
    input(
      message: 'Deploy to production?',
      ok: 'Deploy',
      submitter: 'production-admins'
    )
  }
}
```

### Approval with Variables

```groovy
stage('Approval Gate') {
  steps {
    def approval = input(
      message: 'Deploy to production?',
      ok: 'Deploy',
      parameters: [
        booleanParam(defaultValue: false, description: 'Confirm deployment', name: 'CONFIRM'),
        string(name: 'VERSION', defaultValue: '1.0.0', description: 'Version to deploy')
      ]
    )
    echo "Deploying version: ${approval.VERSION}"
  }
}
```

### Timeout for Approval

```groovy
stage('Manual Approval') {
  steps {
    timeout(time: 1, unit: 'HOURS') {
      input message: 'Proceed with production deployment?', ok: 'Deploy'
    }
  }
}
```

## Milestone Step for Tracking

Mark significant points in deployment workflow.

```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'mvn clean package'
        milestone(ordinal: 1, label: 'Build Complete')
      }
    }
    stage('Staging') {
      steps {
        sh 'kubectl apply -f staging.yaml'
        milestone(ordinal: 2, label: 'Staging Deployment Complete')
      }
    }
    stage('Production') {
      steps {
        sh 'kubectl apply -f prod.yaml'
        milestone(ordinal: 3, label: 'Production Deployment Complete')
      }
    }
  }
}
```

## Lock Step for Resource Locking

The Lockable Resources plugin prevents concurrent access to protected resources.

### Basic Lock

```groovy
stage('Deploy Database') {
  steps {
    lock('prod-database') {
      sh 'flyway migrate -schemas=public'
    }
  }
}
```

### Lock with Timeout

```groovy
stage('Deploy Production') {
  steps {
    lock(resource: 'prod-environment', skipIfLocked: false, timeout: 3600) {
      sh 'kubectl apply -f prod-deployment.yaml'
    }
  }
}
```

### Multiple Locks

```groovy
stage('Multi-Resource Deployment') {
  steps {
    lock([resource: 'load-balancer', skipIfLocked: false],
         [resource: 'database', skipIfLocked: false]) {
      sh 'deploy.sh'
    }
  }
}
```

## Environment-Specific Jenkinsfiles

Use separate Jenkinsfiles or parameter-driven configurations for different environments.

### Parameter-Driven Approach

```groovy
pipeline {
  agent any
  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'production'], description: 'Deployment environment')
  }
  stages {
    stage('Deploy') {
      steps {
        script {
          def config = [:]
          config['dev'] = 'dev-deployment.yaml'
          config['staging'] = 'staging-deployment.yaml'
          config['production'] = 'prod-deployment.yaml'

          sh "kubectl apply -f ${config[params.ENVIRONMENT]} -n ${params.ENVIRONMENT}"
        }
      }
    }
  }
}
```

### Shared Jenkinsfile via Shared Libraries

```groovy
@Library('deployment-library') _

pipeline {
  agent any
  stages {
    stage('Deploy') {
      steps {
        script {
          deployToEnvironment(env: 'production', version: '1.2.3')
        }
      }
    }
  }
}
```

## Promotion Pattern

Promote artifacts through environments using parameterized builds or the Promoted Builds plugin.

### Manual Promotion with Input

```groovy
pipeline {
  agent any
  stages {
    stage('Build & Push to Staging') {
      steps {
        sh 'mvn clean package'
        sh 'docker build -t myapp:$BUILD_NUMBER .'
        sh 'docker tag myapp:$BUILD_NUMBER myapp:latest-staging'
      }
    }
    stage('Test Staging') {
      steps {
        sh 'helm upgrade myapp-staging ./helm --values staging-values.yaml'
        sh 'bash test-e2e.sh staging'
      }
    }
    stage('Promote to Production') {
      steps {
        input message: 'Promote to production?', ok: 'Promote'
        sh 'docker tag myapp:$BUILD_NUMBER myapp:latest-prod'
        sh 'docker push myapp:latest-prod'
      }
    }
  }
}
```

### Copy Artifacts for Promotion

Use the `copyArtifacts` plugin to re-deploy a previous build.

```groovy
pipeline {
  agent any
  stages {
    stage('Promote Previous Build') {
      steps {
        script {
          def build = input(
            message: 'Select build to promote',
            parameters: [
              string(name: 'BUILD_NUMBER', description: 'Jenkins build number to promote')
            ]
          )

          copyArtifacts(
            projectName: 'myapp',
            selector: specific(build.BUILD_NUMBER)
          )

          sh 'kubectl apply -f deployment.yaml'
        }
      }
    }
  }
}
```

## Parameterized Builds

Use parameters to control deployment behavior.

```groovy
pipeline {
  agent any
  parameters {
    string(name: 'VERSION', defaultValue: '1.0.0', description: 'App version to deploy')
    choice(name: 'REPLICAS', choices: ['1', '2', '3', '5'], description: 'Number of replicas')
    booleanParam(name: 'ENABLE_DEBUG', defaultValue: false, description: 'Enable debug logging')
    string(name: 'DEPLOYMENT_TIMEOUT', defaultValue: '600', description: 'Timeout in seconds')
  }
  stages {
    stage('Deploy') {
      steps {
        script {
          sh """
            kubectl set image deployment/app app=myapp:${params.VERSION} -n production
            kubectl scale deployment/app --replicas=${params.REPLICAS} -n production
            kubectl rollout status deployment/app -n production --timeout=${params.DEPLOYMENT_TIMEOUT}s
          """
        }
      }
    }
  }
}
```

## Build Step for Downstream Triggers

Trigger other jobs as part of deployment workflow.

```groovy
stage('Deploy and Run E2E Tests') {
  steps {
    sh 'kubectl apply -f deployment.yaml'

    build job: 'e2e-tests',
          parameters: [
            string(name: 'APP_URL', value: 'http://app-prod:8080'),
            string(name: 'VERSION', value: '1.2.3')
          ],
          wait: true,
          propagate: true
  }
}
```

### Wait and Fail on Downstream Build Failure

```groovy
stage('Run Smoke Tests') {
  steps {
    def result = build(
      job: 'smoke-tests',
      parameters: [
        string(name: 'ENVIRONMENT', value: 'production')
      ],
      propagate: false
    )

    if (result.result == 'FAILURE') {
      sh 'kubectl rollout undo deployment/app -n production'
      error('Smoke tests failed, deployment rolled back')
    }
  }
}
```

## Related Patterns

- Use `milestone()` to track deployment progress and prevent older builds from overwriting newer ones
- Use `lock()` to prevent concurrent deployments to the same environment
- Use `input()` with `submitter` to enforce approval by specific roles
- Use parameterized builds to control deployment behavior without modifying the Jenkinsfile
- Use `copyArtifacts` to promote pre-built artifacts rather than rebuilding
