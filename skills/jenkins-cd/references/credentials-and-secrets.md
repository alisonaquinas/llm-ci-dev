# Credentials and Secrets

Manage sensitive data in Jenkins using the Credentials store, external vaults, and secure binding patterns.

## Jenkins Credentials Store

Jenkins stores credentials in its encrypted configuration directory. Access the Credentials page at `/credentials/` on your Jenkins instance.

### Credentials Store Types

- **Username & Password** — Basic credentials for authentication (Docker, Nexus, etc.)
- **Secret Text** — API tokens, SSH keys, keys from secret management systems
- **SSH Key Pair** — Passwordless SSH authentication to remote hosts
- **Certificate** — X.509 certificates and keystores for mutual TLS
- **File** — Upload sensitive files (e.g., deployment keys)
- **Vault Credentials** — Native integration with HashiCorp Vault (requires Vault plugin)

### Creating Credentials via Jenkins UI

1. Navigate to **Manage Jenkins** → **Credentials** → **System** → **Global credentials**
2. Click **Add Credentials**
3. Choose credential type (e.g., "Username and password")
4. Fill in details and assign a unique ID (e.g., `docker-hub`, `prod-api-token`)
5. Save

### Creating Credentials via Jenkins Configuration as Code (JCasC)

```yaml
credentials:
  system:
    domainCredentials:
      - credentials:
          - basic:
              scope: GLOBAL
              id: "docker-hub"
              username: "myuser"
              password: "${DOCKER_PASSWORD}"
          - vaultString:
              scope: GLOBAL
              id: "slack-token"
              secret: "${SLACK_TOKEN}"
```

## withCredentials Binding

Use `withCredentials` to securely bind credentials to environment variables.

### Username & Password Binding

```groovy
withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
  sh '''
    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
    docker push myapp:latest
  '''
}
```

### Multiple Credentials

```groovy
withCredentials([
  usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS'),
  string(credentialsId: 'slack-token', variable: 'SLACK_TOKEN'),
  file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
]) {
  sh 'echo "Authenticated to Docker, Slack, and Kubernetes"'
}
```

### SSH Key Binding

```groovy
withCredentials([sshUserPrivateKey(credentialsId: 'deploy-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
  sh '''
    ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SSH_USER@prod-server.com "deploy.sh"
  '''
}
```

### Secret Text Binding

```groovy
withCredentials([string(credentialsId: 'api-token', variable: 'API_TOKEN')]) {
  sh 'curl -H "Authorization: Bearer $API_TOKEN" https://api.example.com/deploy'
}
```

### File Credentials Binding

```groovy
withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
  sh 'kubectl --kubeconfig=$KUBECONFIG_FILE apply -f deployment.yaml'
}
```

## Credentials Scoping

Jenkins credentials can be scoped to specific jobs or globally available.

### Global Scope

Credentials are available to all jobs. Use global scope for shared service accounts.

```groovy
withCredentials([usernamePassword(credentialsId: 'global-docker-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
  sh 'echo "Global credentials available to all jobs"'
}
```

### Job-Specific Scope

Create credentials visible only to a specific job or folder. Navigate to **Job** → **Configure** → **Credentials**.

## Jenkins Environment Variables

Jenkins provides built-in variables that identify the job context.

| Variable | Value |
| --- | --- |
| `JENKINS_URL` | Base URL of Jenkins instance (e.g., `https://jenkins.example.com/`) |
| `JOB_NAME` | Name of the job (e.g., `deploy-app`) |
| `BUILD_NUMBER` | Build number (e.g., `42`) |
| `BUILD_ID` | Build ID in `YEAR-MONTH-DAY_HOUR-MINUTE-SECOND` format |
| `WORKSPACE` | Path to the job workspace on the agent |

### Using JENKINS_URL and JOB_NAME

```groovy
stage('Notify Deployment') {
  steps {
    sh '''
      curl -X POST \
        -H "Authorization: Bearer $SLACK_TOKEN" \
        https://slack.com/api/chat.postMessage \
        -d "channel=#deployments&text=Job: ${JOB_NAME} Build: ${BUILD_NUMBER} - Jenkins URL: ${JENKINS_URL}job/${JOB_NAME}/${BUILD_NUMBER}/"
    '''
  }
}
```

## HashiCorp Vault Plugin

Integrate Jenkins with Vault for centralized secret management.

### Install & Configure Vault Plugin

1. **Install Plugin** — Manage Jenkins → Plugin Manager → Search "Vault" → Install "HashiCorp Vault"
2. **Configure Vault** — Manage Jenkins → Configure System → HashiCorp Vault
   - Vault URL: `https://vault.example.com`
   - Vault Credential: Use "Vault Token" credential type
   - Engine Version: 2 (KV v2 is default)

### Reading Secrets from Vault

```groovy
pipeline {
  agent any
  stages {
    stage('Deploy with Vault Secrets') {
      steps {
        script {
          withVault([
            vaultSecrets: [
              [path: 'secret/data/prod/db', secretValues: [[envVar: 'DB_PASSWORD', vaultKey: 'password']]],
              [path: 'secret/data/prod/api', secretValues: [[envVar: 'API_KEY', vaultKey: 'key']]]
            ]
          ]) {
            sh 'kubectl set env deployment/app DB_PASSWORD=$DB_PASSWORD API_KEY=$API_KEY -n production'
          }
        }
      }
    }
  }
}
```

### Vault KV v2 Path Structure

For KV v2 secrets at path `secret/data/prod/db`:

- **Vault Path** — `secret/data/prod/db` (note `data` in path for KV v2)
- **Access from Jenkins** — Use `vaultSecrets` block with the full path

## AWS Credentials

### Native AWS Plugin Integration

Install the **AWS Steps** plugin and configure AWS credentials in Jenkins.

```groovy
withAWS(credentials: 'aws-account', region: 'us-east-1') {
  sh 'aws s3 cp deployment.jar s3://my-bucket/deployments/'
}
```

### Using AWS Credentials as Environment Variables

```groovy
withCredentials([
  string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
  string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
]) {
  sh '''
    aws ec2 describe-instances --region us-east-1
    aws ecs update-service --cluster prod --service myapp --force-new-deployment
  '''
}
```

## Kubernetes Secrets in Pod Agents

For agents running in Kubernetes pods, mount Kubernetes secrets as Jenkins credentials.

### Kubernetes Service Account Binding

```groovy
podTemplate(containers: [containerTemplate(
  name: 'kubectl',
  image: 'bitnami/kubectl:latest',
  command: 'cat',
  ttyEnabled: true,
  envVars: [envVar(key: 'KUBECONFIG', value: '/var/run/secrets/kubernetes.io/serviceaccount/kubeconfig')]
)]) {
  node(POD_LABEL) {
    container('kubectl') {
      sh 'kubectl apply -f deployment.yaml'
    }
  }
}
```

### Mount Kubernetes Secret as File

```groovy
podTemplate(
  containers: [containerTemplate(name: 'kubectl', image: 'bitnami/kubectl:latest', ttyEnabled: true)],
  volumes: [secretVolume(secretName: 'deploy-token', mountPath: '/var/secrets')]
) {
  node(POD_LABEL) {
    container('kubectl') {
      sh 'cat /var/secrets/token'
    }
  }
}
```

## Credential Rotation

Rotate credentials regularly to minimize breach impact.

### Automation Pattern with Vault

```groovy
pipeline {
  agent any
  triggers {
    cron('H 2 1 * *') // First day of each month at 2 AM
  }
  stages {
    stage('Rotate Database Password') {
      steps {
        script {
          withVault([vaultSecrets: [[path: 'secret/data/db', secretValues: [[envVar: 'OLD_PASSWORD', vaultKey: 'password']]]]]) {
            sh 'vault write -f secret/rotate/db/password old_password=$OLD_PASSWORD'
          }
        }
      }
    }
    stage('Update Deployments') {
      steps {
        // Wait for new secret to be available in Vault
        sleep(time: 5, unit: 'SECONDS')
        sh 'kubectl rollout restart deployment/app -n production'
      }
    }
  }
}
```

### Manual Rotation Steps

1. Generate new credential in your secret store (Vault, AWS Secrets Manager, etc.)
2. Update Jenkins Credentials store with new value
3. Trigger a deployment to apply new credentials
4. Archive old credential
5. Monitor application logs for authentication errors

## Best Practices

- **Never log credentials** — Use `withCredentials` to automatically mask values in logs
- **Scope credentials appropriately** — Use job-specific credentials for sensitive environments
- **Rotate regularly** — Establish a credential rotation schedule
- **Use separate credentials per environment** — Never reuse production credentials for staging
- **Audit credential access** — Enable Jenkins audit logging and monitor credential usage
- **Integrate with external systems** — Use Vault, AWS Secrets Manager, or similar for centralized management
