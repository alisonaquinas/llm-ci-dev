# Strategies and Rollback

Advanced deployment strategies for safe production rollouts: blue-green, canary, rolling updates, and rollback patterns.

## Blue-Green Deployments

Deploy the new version ("green") alongside the current version ("blue"), then switch traffic after verification.

### Kubernetes Blue-Green Pattern

```groovy
pipeline {
  agent any
  stages {
    stage('Deploy Green Version') {
      steps {
        sh '''
          kubectl create deployment app-green --image=myapp:${BUILD_NUMBER} -n production
          kubectl expose deployment app-green --port=8080 --type=LoadBalancer -n production
        '''
      }
    }
    stage('Test Green Version') {
      steps {
        retry(5) {
          sh 'curl -f http://app-green-service:8080/health'
        }
      }
    }
    stage('Switch Traffic to Green') {
      steps {
        input message: 'Switch traffic to green?', ok: 'Switch'
        sh '''
          kubectl patch service app-production -p '{"spec":{"selector":{"deployment":"app-green"}}}'
          echo "Traffic switched to green version"
        '''
      }
    }
    stage('Cleanup Blue Version') {
      steps {
        sh 'kubectl delete deployment app-blue -n production'
      }
    }
  }
}
```

### AWS ECS Blue-Green with CodeDeploy

```groovy
stage('Create Green Task Set') {
  steps {
    withAWS(credentials: 'aws-prod', region: 'us-east-1') {
      sh '''
        aws ecs create-task-set \
          --service myapp-service \
          --cluster prod-cluster \
          --task-definition myapp:${BUILD_NUMBER} \
          --scale value=100,unit=PERCENT \
          --load-balancer targetGroupArn=arn:aws:elasticloadbalancing:...,containerName=myapp,containerPort=8080
      '''
    }
  }
}

stage('Test Green Task Set') {
  steps {
    // Health check against green task set
    sh 'bash test-health-check.sh'
  }
}

stage('Switch Traffic to Green') {
  steps {
    input message: 'Switch to green?', ok: 'Switch'
    withAWS(credentials: 'aws-prod', region: 'us-east-1') {
      sh '''
        aws ecs update-service \
          --cluster prod-cluster \
          --service myapp-service \
          --deployment-configuration maximumPercent=200,minimumHealthyPercent=100 \
          --primary-task-set ${GREEN_TASK_SET_ARN}
      '''
    }
  }
}
```

## Canary Deployments

Deploy to a small percentage of users first, monitor metrics, then gradually increase traffic.

### Kubernetes Canary with Flagger

Canary deployments with automated promotion based on metrics.

```groovy
pipeline {
  agent any
  stages {
    stage('Create Canary Release') {
      steps {
        sh '''
          cat > canary.yaml << EOF
          apiVersion: flagger.app/v1beta1
          kind: Canary
          metadata:
            name: myapp
            namespace: production
          spec:
            targetRef:
              apiVersion: apps/v1
              kind: Deployment
              name: myapp
            progressDeadlineSeconds: 300
            service:
              port: 8080
            analysis:
              interval: 1m
              threshold: 5
              metrics:
              - name: error-rate
                thresholdRange:
                  max: 1
              - name: latency
                thresholdRange:
                  max: 500
            skipAnalysis: false
            stages:
            - weight: 10
            - weight: 50
            - weight: 100
          EOF

          kubectl apply -f canary.yaml
        '''
      }
    }
    stage('Monitor Canary') {
      steps {
        sh '''
          # Wait for canary analysis to complete
          kubectl wait --for=condition=succeeded canary/myapp -n production --timeout=10m
          echo "Canary promotion successful"
        '''
      }
    }
  }
}
```

### Manual Canary with Traffic Splitting

```groovy
pipeline {
  agent any
  stages {
    stage('Deploy Canary (10% Traffic)') {
      steps {
        sh '''
          kubectl set image deployment/app-canary app=myapp:${BUILD_NUMBER} -n production
          # Use Istio/Flagger or manual service mesh config to send 10% traffic to canary
        '''
      }
    }
    stage('Monitor Canary Metrics') {
      steps {
        sh '''
          # Poll Prometheus or similar for canary metrics
          for i in {1..30}; do
            ERROR_RATE=$(curl -s "http://prometheus:9090/api/v1/query?query=rate(http_requests_total%7bjob%3d%22app-canary%22%7d%5b5m%5d)" | jq '.data.result[0].value[1]')
            if (( $(echo "$ERROR_RATE > 0.05" | bc -l) )); then
              echo "Canary error rate too high: $ERROR_RATE"
              exit 1
            fi
            echo "Canary check $i: error rate OK"
            sleep 60
          done
        '''
      }
    }
    stage('Promote Canary to 50%') {
      steps {
        input message: 'Promote canary to 50% traffic?', ok: 'Promote'
        sh 'kubectl set image deployment/app-stable app=myapp:${BUILD_NUMBER} -n production'
      }
    }
  }
}
```

## Rolling Updates with Kubernetes

Gradually replace old pods with new ones, maintaining service availability.

### RollingUpdate Strategy in Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: myapp:latest
```

### Rolling Update via kubectl

```groovy
stage('Perform Rolling Update') {
  steps {
    sh '''
      kubectl set image deployment/myapp myapp=myapp:${BUILD_NUMBER} -n production
      kubectl rollout status deployment/myapp -n production --timeout=10m
      # Monitor pod replacement progress
      kubectl get pods -n production -l app=myapp -w
    '''
  }
}
```

## Rollback Patterns

### Kubernetes Rollback

Revert to previous deployment version if health checks fail.

```groovy
stage('Deploy') {
  steps {
    sh 'kubectl set image deployment/app app=myapp:${BUILD_NUMBER} -n production'
  }
  post {
    failure {
      sh 'kubectl rollout undo deployment/app -n production'
    }
  }
}
```

### Health Check with Automatic Rollback

```groovy
stage('Verify Deployment') {
  steps {
    script {
      def healthCheckPassed = false
      try {
        retry(10) {
          sh '''
            HEALTH=$(curl -s http://app-prod:8080/health)
            if [[ "$HEALTH" != *"UP"* ]]; then
              exit 1
            fi
          '''
          healthCheckPassed = true
        }
      } catch (Exception e) {
        sh 'kubectl rollout undo deployment/app -n production'
        sh 'kubectl rollout status deployment/app -n production'
        error("Health check failed, rolled back to previous version")
      }
    }
  }
}
```

### Rollback to Specific Previous Build

```groovy
stage('Rollback to Previous Build') {
  steps {
    script {
      input(
        message: 'Select build to rollback to',
        parameters: [
          string(name: 'ROLLBACK_BUILD', description: 'Jenkins build number')
        ]
      )

      def previousImage = "myapp:${params.ROLLBACK_BUILD}"
      sh "kubectl set image deployment/app app=${previousImage} -n production"
      sh 'kubectl rollout status deployment/app -n production'
    }
  }
}
```

### AWS CodeDeploy Rollback

```groovy
stage('Deploy with Automatic Rollback') {
  steps {
    withAWS(credentials: 'aws-prod', region: 'us-east-1') {
      sh '''
        DEPLOYMENT_ID=$(aws deploy create-deployment \
          --application-name myapp \
          --deployment-group-name production \
          --revision revisionType=S3,s3Location=s3://deployments/myapp-${BUILD_NUMBER}.zip \
          --auto-rollback-configuration enabled=true,events=DEPLOYMENT_FAILURE,DEPLOYMENT_STOP_ON_TIMEOUT \
          --query 'deploymentId' \
          --output text)

        aws deploy wait deployment-successful --deployment-id $DEPLOYMENT_ID
      '''
    }
  }
}
```

## Build History for Artifact Lookup

Access previous builds to retrieve artifacts for rollback scenarios.

### Finding a Previous Build Artifact

```groovy
pipeline {
  agent any
  stages {
    stage('Get Previous Build') {
      steps {
        script {
          // Get the previous successful build
          def previousBuild = currentBuild.previousCompletedBuild

          if (previousBuild) {
            def artifacts = previousBuild.artifacts
            artifacts.each { artifact ->
              println "Found artifact: ${artifact.name} from build ${previousBuild.number}"
            }
          }
        }
      }
    }
  }
}
```

### Querying Build History

```groovy
stage('Find Build Artifact') {
  steps {
    script {
      // Access Jenkins API to find a specific build
      def buildNumber = params.BUILD_NUMBER_TO_DEPLOY ?: currentBuild.number - 1
      def job = Jenkins.instance.getItem('myapp')
      def build = job.getBuildByNumber(buildNumber)

      if (build) {
        println "Found build: ${build.displayName}"
        build.artifacts.each { artifact ->
          println "Artifact: ${artifact.name}"
        }
      }
    }
  }
}
```

## Copy Artifacts Plugin for Promotion

Use `copyArtifacts` to promote pre-built artifacts to higher environments without rebuilding.

### Copy from Previous Build

```groovy
stage('Promote Previous Build') {
  steps {
    copyArtifacts(
      projectName: 'myapp',
      selector: lastSuccessful(),
      fingerprintArtifacts: true
    )

    sh '''
      ls -la
      docker load < app-image.tar
      docker tag myapp:latest myapp:prod
      docker push myapp:prod
    '''
  }
}
```

### Copy from Specific Build

```groovy
stage('Deploy Artifact from Build') {
  steps {
    copyArtifacts(
      projectName: 'myapp',
      selector: specific('${BUILD_NUMBER_TO_DEPLOY}'),
      fingerprintArtifacts: true
    )

    sh 'kubectl apply -f deployment.yaml'
  }
}
```

### Cross-Job Artifact Copy

```groovy
stage('Copy Build Artifact') {
  steps {
    copyArtifacts(
      projectName: 'upstream-job',
      selector: lastSuccessful(),
      target: 'upstream-artifacts',
      fingerprintArtifacts: true
    )

    sh 'cat upstream-artifacts/version.txt'
  }
}
```

## Canary with Prometheus Metrics

Monitor custom metrics during canary deployment.

```groovy
stage('Canary Deployment') {
  steps {
    sh 'kubectl apply -f canary-deployment.yaml'
  }
  post {
    always {
      script {
        def metricsQuery = '''
          {
            "prometheusUrl": "http://prometheus:9090",
            "query": "rate(http_requests_total{app=\\"myapp-canary\\"}[5m])",
            "threshold": 0.5
          }
        '''

        sh '''
          for i in {1..10}; do
            curl -s "http://prometheus:9090/api/v1/query?query=rate(http_requests_total%7bapp%3d%22myapp-canary%22%7d%5b5m%5d)" | jq '.data.result'
            sleep 30
          done
        '''
      }
    }
  }
}
```

## Related Strategies

- Use **Blue-Green** for zero-downtime deployments with instant rollback capability
- Use **Canary** to detect issues early with real traffic before full rollout
- Use **Rolling Updates** for gradual pod replacement while maintaining availability
- Use **Artifact Promotion** to avoid rebuilding and ensure consistency across environments
- Use **Health Checks** to detect deployment failures and trigger automatic rollback
- Use **Build History** to retrieve previous artifacts and enable fast rollback
