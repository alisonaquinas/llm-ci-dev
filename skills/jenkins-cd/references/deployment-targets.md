# Deployment Targets

Deploy applications to diverse platforms: Kubernetes, AWS, Docker registries, SSH hosts, Ansible, artifact repositories, and more.

## Kubernetes Deployments

### kubectl Apply Pattern

```groovy
stage('Deploy to Kubernetes') {
  steps {
    sh 'kubectl apply -f deployment.yaml -n production'
    sh 'kubectl rollout status deployment/app -n production --timeout=5m'
  }
}
```

### Kubectl with Custom Kubeconfig

```groovy
withCredentials([file(credentialsId: 'kubeconfig-prod', variable: 'KUBECONFIG_FILE')]) {
  sh '''
    kubectl --kubeconfig=$KUBECONFIG_FILE apply -f deployment.yaml
    kubectl --kubeconfig=$KUBECONFIG_FILE get deployments -n production
  '''
}
```

### Set Image and Rollout

```groovy
stage('Update Container Image') {
  steps {
    sh '''
      kubectl set image deployment/app \
        app=myregistry.azurecr.io/myapp:${BUILD_NUMBER} \
        -n production
      kubectl rollout status deployment/app -n production
    '''
  }
}
```

### Scale Deployments

```groovy
stage('Scale Application') {
  steps {
    sh 'kubectl scale deployment/app --replicas=5 -n production'
  }
}
```

## Helm Deployments

### Helm Chart Deployment

```groovy
stage('Deploy with Helm') {
  steps {
    sh '''
      helm upgrade --install myapp ./helm-chart \
        --namespace production \
        --values prod-values.yaml \
        --set image.tag=${BUILD_NUMBER} \
        --wait
    '''
  }
}
```

### Helm with Custom Values

```groovy
stage('Helm Deploy') {
  steps {
    sh '''
      helm upgrade myapp ./chart \
        --namespace production \
        --values values.yaml \
        --set replicas=3,image.tag=1.2.3 \
        --timeout 10m \
        --wait-for-jobs
    '''
  }
}
```

## AWS Deployments

### EC2 Deployment with AWS CLI

```groovy
withAWS(credentials: 'aws-prod', region: 'us-east-1') {
  sh '''
    aws ec2 describe-instances --filters "Name=tag:Environment,Values=production" --query 'Reservations[*].Instances[*].[InstanceId,PrivateIpAddress]'
    aws ssm send-command --instance-ids i-1234567890abcdef0 --document-name "AWS-RunShellScript" --parameters 'commands=["cd /app && ./deploy.sh"]'
  '''
}
```

### ECS Deployment

```groovy
stage('Deploy to ECS') {
  steps {
    script {
      withAWS(credentials: 'aws-prod', region: 'us-east-1') {
        sh '''
          aws ecs update-service \
            --cluster production-cluster \
            --service myapp-service \
            --force-new-deployment
          aws ecs wait services-stable --cluster production-cluster --services myapp-service
        '''
      }
    }
  }
}
```

### Lambda Function Deployment

```groovy
stage('Deploy Lambda') {
  steps {
    sh '''
      zip function.zip lambda_function.py
      aws lambda update-function-code \
        --function-name my-function \
        --zip-file fileb://function.zip
      aws lambda update-function-configuration \
        --function-name my-function \
        --environment Variables={ENV=prod}
    '''
  }
}
```

### S3 + CloudFront Deployment

```groovy
stage('Deploy Static Site') {
  steps {
    withAWS(credentials: 'aws-prod', region: 'us-east-1') {
      sh '''
        aws s3 sync ./dist s3://my-website-bucket --delete
        aws cloudfront create-invalidation --distribution-id E1234567890ABC --paths "/*"
      '''
    }
  }
}
```

### CodeDeploy Deployment

```groovy
stage('Deploy via CodeDeploy') {
  steps {
    withAWS(credentials: 'aws-prod', region: 'us-east-1') {
      sh '''
        aws deploy create-deployment \
          --application-name myapp \
          --deployment-group-name production \
          --revision revisionType=S3,s3Location=s3://deployments-bucket/myapp-${BUILD_NUMBER}.zip \
          --deployment-config-name CodeDeployDefault.OneAtATime
      '''
    }
  }
}
```

## Docker Registry Deployments

### Push to Docker Hub

```groovy
stage('Push to Docker Hub') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
      sh '''
        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
        docker build -t $DOCKER_USER/myapp:${BUILD_NUMBER} .
        docker tag $DOCKER_USER/myapp:${BUILD_NUMBER} $DOCKER_USER/myapp:latest
        docker push $DOCKER_USER/myapp:${BUILD_NUMBER}
        docker push $DOCKER_USER/myapp:latest
      '''
    }
  }
}
```

### Push to AWS ECR

```groovy
stage('Push to ECR') {
  steps {
    script {
      withAWS(credentials: 'aws-prod', region: 'us-east-1') {
        sh '''
          aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
          docker build -t myapp:${BUILD_NUMBER} .
          docker tag myapp:${BUILD_NUMBER} 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
          docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
        '''
      }
    }
  }
}
```

### Push to Azure Container Registry

```groovy
stage('Push to ACR') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'acr-creds', usernameVariable: 'ACR_USER', passwordVariable: 'ACR_PASS')]) {
      sh '''
        echo $ACR_PASS | docker login -u $ACR_USER --password-stdin myregistry.azurecr.io
        docker build -t myregistry.azurecr.io/myapp:${BUILD_NUMBER} .
        docker push myregistry.azurecr.io/myapp:${BUILD_NUMBER}
      '''
    }
  }
}
```

## SSH Deployment

### SSH Agent Deployment

```groovy
stage('Deploy via SSH') {
  steps {
    withCredentials([sshUserPrivateKey(credentialsId: 'deploy-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
      sh '''
        ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SSH_USER@prod-server.com << 'EOF'
          cd /app
          git pull origin main
          ./deploy.sh
          systemctl restart myapp
        EOF
      '''
    }
  }
}
```

### Multi-Host SSH Deployment

```groovy
stage('Deploy to Multiple Hosts') {
  steps {
    withCredentials([sshUserPrivateKey(credentialsId: 'deploy-key', keyFileVariable: 'SSH_KEY')]) {
      sh '''
        for host in prod-1 prod-2 prod-3; do
          ssh -i $SSH_KEY -o StrictHostKeyChecking=no deploy@${host}.example.com "bash /opt/deploy.sh"
        done
      '''
    }
  }
}
```

## Ansible Deployments

### Ansible Playbook Execution

```groovy
stage('Deploy with Ansible') {
  steps {
    sh '''
      ansible-playbook -i inventory/prod -e "app_version=${BUILD_NUMBER}" deploy.yml
    '''
  }
}
```

### Ansible with Vault Encryption

```groovy
stage('Deploy with Ansible Vault') {
  steps {
    withCredentials([file(credentialsId: 'ansible-vault-pass', variable: 'VAULT_PASS_FILE')]) {
      sh '''
        ansible-playbook \
          -i inventory/prod \
          --vault-password-file=$VAULT_PASS_FILE \
          -e "app_version=${BUILD_NUMBER}" \
          deploy.yml
      '''
    }
  }
}
```

## Application Server Deployments

### Tomcat Deployment

```groovy
stage('Deploy to Tomcat') {
  steps {
    sh '''
      scp -r target/app.war deploy@tomcat-server:/opt/tomcat/webapps/
      ssh deploy@tomcat-server "sudo systemctl restart tomcat"
    '''
  }
}
```

## Artifact Repository Promotion

### Nexus Artifact Promotion

```groovy
stage('Promote to Nexus Release') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
      sh '''
        curl -v -X POST \
          -u $NEXUS_USER:$NEXUS_PASS \
          "http://nexus.example.com/service/rest/v1/staging/repositories/releases" \
          -H "Content-Type: application/json" \
          -d '{"name":"myapp-${BUILD_NUMBER}"}'
      '''
    }
  }
}
```

### Artifactory Promotion

```groovy
stage('Promote in Artifactory') {
  steps {
    withCredentials([string(credentialsId: 'artifactory-api-key', variable: 'ARTIFACTORY_API_KEY')]) {
      sh '''
        curl -H "X-JFrog-Art-Api:$ARTIFACTORY_API_KEY" \
          -X POST \
          "https://artifactory.example.com/artifactory/api/promote/myapp/${BUILD_NUMBER}/promote" \
          -H "Content-Type: application/json" \
          -d '{"targetRepo":"prod-release","artifacts":true}'
      '''
    }
  }
}
```

### Maven Repository Deployment

```groovy
stage('Deploy to Maven Repository') {
  steps {
    sh '''
      mvn deploy \
        -Dmaven.test.skip=true \
        -Drevision=${BUILD_NUMBER} \
        -Dchangelist= \
        -Dsha1=
    '''
  }
}
```

## S3 + CloudFront CDN Deployment

### S3 Static Site with CloudFront Invalidation

```groovy
stage('Deploy to S3 CDN') {
  steps {
    withAWS(credentials: 'aws-prod', region: 'us-east-1') {
      sh '''
        aws s3 sync ./build s3://my-static-site --delete
        aws cloudfront create-invalidation --distribution-id E1234567890ABC --paths "/*"
        echo "Deployment complete. CDN cache invalidated."
      '''
    }
  }
}
```

## Deployment Health Check

### Post-Deployment Verification

```groovy
stage('Verify Deployment') {
  steps {
    retry(5) {
      sh 'curl -f http://app-prod:8080/health && echo "Health check passed"'
    }
  }
  post {
    failure {
      sh 'kubectl rollout undo deployment/app -n production'
    }
  }
}
```

## Related Patterns

- Use credentials bindings with environment variables for cloud provider authentication
- Leverage managed services (ECS, Lambda) to reduce operational overhead
- Implement health checks after deployments to verify application availability
- Use artifact repositories for artifact promotion workflows rather than rebuilding
