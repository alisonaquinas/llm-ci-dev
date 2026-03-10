---
name: jenkins-cd
description: >
  Deploy applications with Jenkins Pipeline stages.
  Configure deployment workflows, manage credentials, target diverse platforms, and implement advanced deployment strategies.
---

# Jenkins CD

Configure Jenkins Pipeline stages for application deployments. This skill covers deployment patterns, credential management, deployment targets, and strategies for safe production rollouts.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Deployment Stages | `references/deployment-stages.md` | Configuring approval gates, milestone tracking, resource locking, and promotion patterns |
| Credentials & Secrets | `references/credentials-and-secrets.md` | Managing Jenkins Credentials, binding secrets, integrating external vaults, and rotation |
| Deployment Targets | `references/deployment-targets.md` | Deploying to Kubernetes, AWS, Docker, SSH hosts, Ansible, artifact repositories |
| Strategies & Rollback | `references/strategies-and-rollback.md` | Blue-green, canary, rolling updates, rollback patterns, artifact promotion |

---

## Quick Start

### Basic Deployment Stage Pattern

```groovy
pipeline {
  agent any
  stages {
    stage('Deploy to Staging') {
      steps {
        sh 'kubectl apply -f staging-deployment.yaml'
        sh 'kubectl rollout status deployment/app -n staging'
      }
    }
    stage('Approval Gate') {
      steps {
        input message: 'Approve production deployment?', ok: 'Deploy'
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

### Input Step for Approval

```groovy
stage('Promote to Production') {
  steps {
    input(
      id: 'approve',
      message: 'Deploy to production?',
      ok: 'Deploy',
      submitter: 'admin-group'
    )
    echo 'Approved by: ${APPROVED_BY}'
  }
}
```

### Lockable Resources Plugin

```groovy
stage('Deploy Database') {
  steps {
    lock('prod-database') {
      sh 'flyway migrate -schemas=public -locations=filesystem:./migrations'
    }
  }
}
```

### Credentials Binding

```groovy
stage('Deploy') {
  steps {
    withCredentials([
      usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS'),
      string(credentialsId: 'slack-token', variable: 'SLACK_TOKEN')
    ]) {
      sh '''
        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
        docker push myapp:latest
      '''
    }
  }
}
```

### Post-Deploy Health Check

```groovy
stage('Verify Deployment') {
  steps {
    retry(3) {
      sh 'curl -f http://app-prod:8080/health || exit 1'
    }
  }
  post {
    failure {
      sh 'kubectl rollout undo deployment/app -n production'
    }
  }
}
```

---

## Related References

- Load **Deployment Stages** to understand input steps, milestone tracking, and resource locking
- Load **Credentials & Secrets** to manage Jenkins Credentials store and external vaults
- Load **Deployment Targets** to deploy to Kubernetes, AWS, Docker, SSH, Ansible, artifact repositories
- Load **Strategies & Rollback** for blue-green, canary, rolling updates, and rollback patterns
