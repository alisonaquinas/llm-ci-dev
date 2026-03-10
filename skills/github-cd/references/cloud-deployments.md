# Cloud Deployments

Deploy applications to cloud providers, container registries, and package managers using GitHub Actions.

## AWS Deployments

### ECS (Elastic Container Service)

Deploy containerized applications to ECS clusters:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Build and Push Docker Image
        run: |
          aws ecr get-login-password --region us-east-1 | \
            docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
          docker build -t myapp:$GITHUB_SHA .
          docker tag myapp:$GITHUB_SHA 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
          docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest

      - name: Update ECS Service
        run: |
          aws ecs update-service \
            --cluster production \
            --service myapp \
            --force-new-deployment
```

### EKS (Elastic Kubernetes Service)

Deploy to EKS clusters:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Update kubeconfig
        run: |
          aws eks update-kubeconfig \
            --region us-east-1 \
            --name production-cluster

      - name: Deploy with kubectl
        run: |
          kubectl set image deployment/myapp \
            myapp=123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:$GITHUB_SHA \
            -n production
```

### Lambda

Deploy Lambda functions:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Deploy Lambda Function
        run: |
          zip -r function.zip . -x "*.git*"
          aws lambda update-function-code \
            --function-name myapp \
            --zip-file fileb://function.zip
```

### S3 + CloudFront

Deploy static sites:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Build Static Site
        run: npm run build

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Deploy to S3
        run: |
          aws s3 sync dist/ s3://my-bucket/ --delete

      - name: Invalidate CloudFront
        run: |
          aws cloudfront create-invalidation \
            --distribution-id E123456789 \
            --paths "/*"
```

## GCP Deployments

### Cloud Run

Deploy containerized services to Cloud Run:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: projects/123456789/locations/global/workloadIdentityPools/github-pool/providers/github-provider
          service_account: github-actions@my-project.iam.gserviceaccount.com

      - name: Set up Cloud SDK
        uses: google-github-actions/setup-gcloud@v2

      - name: Deploy to Cloud Run
        run: |
          gcloud run deploy myapp \
            --image gcr.io/my-project/myapp:$GITHUB_SHA \
            --region us-central1 \
            --platform managed \
            --allow-unauthenticated
```

### GKE (Google Kubernetes Engine)

Deploy to GKE clusters:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: projects/123456789/locations/global/workloadIdentityPools/github-pool/providers/github-provider
          service_account: github-actions@my-project.iam.gserviceaccount.com

      - name: Set up Cloud SDK
        uses: google-github-actions/setup-gcloud@v2

      - name: Get GKE Credentials
        run: |
          gcloud container clusters get-credentials production-cluster \
            --zone us-central1-a \
            --project my-project

      - name: Deploy with kubectl
        run: kubectl apply -f k8s/
```

## Azure Deployments

### AKS (Azure Kubernetes Service)

Deploy to AKS clusters:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Set AKS Context
        run: |
          az aks get-credentials \
            --resource-group myapp-rg \
            --name production-aks

      - name: Deploy with kubectl
        run: kubectl apply -f k8s/
```

### App Service

Deploy web applications:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Deploy to App Service
        uses: azure/webapps-deploy@v3
        with:
          app-name: myapp
          package: .
```

## Kubernetes (Generic)

Deploy to any Kubernetes cluster:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set kubeconfig
        run: |
          mkdir -p $HOME/.kube
          echo "${{ secrets.KUBECONFIG }}" | base64 -d > $HOME/.kube/config
          chmod 600 $HOME/.kube/config

      - name: Deploy with kubectl
        run: |
          kubectl apply -f k8s/ --record

      - name: Verify Rollout
        run: |
          kubectl rollout status deployment/myapp -n production
```

## Container Registries

### Docker Hub

Push images to Docker Hub:

```yaml
jobs:
  push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            myusername/myapp:latest
            myusername/myapp:${{ github.sha }}
```

### GitHub Container Registry (GHCR)

Push images to GHCR:

```yaml
jobs:
  push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4

      - name: Log in to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
```

## SSH Deployments

Deploy via SSH to custom infrastructure:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install SSH Key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/deploy_key
          chmod 600 ~/.ssh/deploy_key
          ssh-keyscan -H ${{ secrets.DEPLOY_HOST }} >> ~/.ssh/known_hosts

      - name: Deploy via SSH
        run: |
          ssh -i ~/.ssh/deploy_key deploy@${{ secrets.DEPLOY_HOST }} \
            "cd /app && git pull origin main && npm install && npm run build"
```

## Package Managers

### NPM Publish

Publish packages to npm registry:

```yaml
jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          registry-url: 'https://registry.npmjs.org'

      - name: Install Dependencies
        run: npm install

      - name: Publish to npm
        run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

### PyPI Publish

Publish Python packages to PyPI:

```yaml
jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Build Distribution
        run: |
          pip install build
          python -m build

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
        with:
          repository-url: https://upload.pypi.org/legacy/
```

## Deployment Patterns

### Blue-Green Deployment

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Green Environment
        run: ./deploy.sh green

      - name: Run Health Checks
        run: ./health-check.sh green

      - name: Switch Traffic Blue -> Green
        run: ./switch-traffic.sh blue green

      - name: Cleanup Blue Environment
        run: ./cleanup.sh blue
        if: success()
```

### Canary Deployment

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to Canary (10% traffic)
        run: kubectl set image deployment/myapp-canary myapp=${{ env.IMAGE }} -n production

      - name: Monitor Canary Metrics
        run: ./monitor.sh 5m  # Monitor for 5 minutes

      - name: Roll Out Full Deployment
        run: kubectl set image deployment/myapp myapp=${{ env.IMAGE }} -n production
        if: success()
```
