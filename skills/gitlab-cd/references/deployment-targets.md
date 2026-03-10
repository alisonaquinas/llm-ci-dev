# Deployment Targets

Deploy to various platforms and services from GitLab pipelines.

## Kubernetes Agent

### Agent Configuration

Use the GitLab Kubernetes Agent for native Kubernetes integration:

1. Create `.gitlab/agents/<agent-name>/config.yaml`:

```yaml
gitops:
  manifest_projects:
  - paths:
    - glob: 'k8s/**/*.yaml'
```

1. Register the agent in **Infrastructure > Kubernetes clusters > Connect a cluster**

2. Connect your cluster with:

```bash
helm repo add gitlab https://charts.gitlab.io
helm install gitlab-agent gitlab/gitlab-agent \
  --set gitlabToken=<token> \
  --set gitlabUrl=https://gitlab.com
```

### Deploy via Agent

Reference the agent in deployment jobs:

```yaml
deploy_k8s:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl --kubeconfig=$KUBECONFIG apply -f k8s/
  environment:
    name: kubernetes
    kubernetes:
      namespace: production
```

## AWS Deployment

### AWS ECR (Elastic Container Registry)

Push container images to AWS ECR:

```yaml
push_to_ecr:
  stage: deploy
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
  script:
    - docker build -t $ECR_REPO:$CI_COMMIT_SHA .
    - docker push $ECR_REPO:$CI_COMMIT_SHA
```

### AWS ECS (Elastic Container Service)

Deploy to ECS:

```yaml
deploy_ecs:
  stage: deploy
  image: amazon/aws-cli:latest
  script:
    - aws ecs update-service --cluster $ECS_CLUSTER --service $ECS_SERVICE --force-new-deployment
  environment:
    name: aws-ecs
```

### AWS EKS (Elastic Kubernetes Service)

Deploy to EKS using kubectl:

```yaml
deploy_eks:
  stage: deploy
  image: amazon/aws-cli:latest
  script:
    - aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER
    - kubectl apply -f k8s/deployment.yaml
```

### AWS OIDC Authentication

Use OpenID Connect for secure AWS authentication without long-lived credentials:

1. Set up OIDC in GitLab (**Settings > CI/CD > OpenID Connect Providers**)
2. Configure AWS IAM role to trust GitLab's OIDC provider
3. In job:

```yaml
deploy_to_aws:
  image: amazon/aws-cli:latest
  id_tokens:
    GITLAB_OIDC_TOKEN:
      aud: sts.amazonaws.com
  script:
    - export AWS_ROLE_ARN=arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ROLE
    - export AWS_WEB_IDENTITY_TOKEN_FILE=/tmp/web-identity-token
    - echo $GITLAB_OIDC_TOKEN > $AWS_WEB_IDENTITY_TOKEN_FILE
    - aws sts assume-role-with-web-identity --role-arn $AWS_ROLE_ARN --role-session-name gitlab-deploy --web-identity-token file://$AWS_WEB_IDENTITY_TOKEN_FILE
```

## GCP Deployment

### GCP GKE (Google Kubernetes Engine)

Deploy to GKE:

```yaml
deploy_gke:
  stage: deploy
  image: google/cloud-sdk:latest
  script:
    - gcloud auth activate-service-account --key-file=$GCP_SERVICE_KEY
    - gcloud container clusters get-credentials $GKE_CLUSTER --region=$GCP_REGION
    - kubectl apply -f k8s/
  environment:
    name: gke
```

### GCP Cloud Run

Deploy serverless containers to Cloud Run:

```yaml
deploy_cloud_run:
  stage: deploy
  image: google/cloud-sdk:latest
  script:
    - gcloud auth activate-service-account --key-file=$GCP_SERVICE_KEY
    - gcloud run deploy $SERVICE_NAME --image=$DOCKER_IMAGE --region=$GCP_REGION
  environment:
    name: cloud-run
```

## Heroku Deployment

Deploy to Heroku via Git or API:

```yaml
deploy_heroku:
  stage: deploy
  image: buildpack-deps:focal
  script:
    - git remote add heroku https://git.heroku.com/$HEROKU_APP_NAME.git
    - git push -f heroku main:main
  only:
    - main
  environment:
    name: heroku
    url: https://$HEROKU_APP_NAME.herokuapp.com
```

Or using the Heroku API:

```yaml
deploy_heroku_api:
  stage: deploy
  image: curlimages/curl:latest
  script:
    - curl -X POST https://api.heroku.com/apps/$HEROKU_APP_NAME/dynos \
        -H "Authorization: Bearer $HEROKU_API_KEY" \
        -d '{"command": "python manage.py migrate && gunicorn app:app"}'
```

## Container Registry Integration

### GitLab Container Registry

Push to the built-in GitLab registry:

```yaml
push_registry:
  stage: deploy
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

### Docker Hub

Push to Docker Hub:

```yaml
push_dockerhub:
  stage: deploy
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_TOKEN
    - docker build -t $DOCKER_HUB_REPO:$CI_COMMIT_TAG .
    - docker push $DOCKER_HUB_REPO:$CI_COMMIT_TAG
```

## Package Registry

### npm Registry

Publish npm packages:

```yaml
publish_npm:
  stage: deploy
  image: node:latest
  script:
    - npm config set //registry.npmjs.org/:_authToken=$NPM_TOKEN
    - npm publish
  only:
    - tags
```

### PyPI Registry

Publish Python packages:

```yaml
publish_pypi:
  stage: deploy
  image: python:latest
  script:
    - pip install twine
    - twine upload dist/* -u __token__ -p $PYPI_TOKEN
  only:
    - tags
```

### Maven Repository

Publish Maven packages:

```yaml
publish_maven:
  stage: deploy
  image: maven:latest
  script:
    - mvn deploy -Dmaven.repo.local=$CI_PROJECT_DIR/.m2 -s $CI_PROJECT_DIR/settings.xml
  only:
    - tags
```

## SSH Deployment

Deploy via SSH to custom servers:

```yaml
deploy_ssh:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add openssh-client
    - mkdir -p ~/.ssh
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' > ~/.ssh/deploy_key
    - chmod 600 ~/.ssh/deploy_key
    - ssh-keyscan -H $DEPLOY_HOST >> ~/.ssh/known_hosts
  script:
    - scp -i ~/.ssh/deploy_key -r dist/ deploy@$DEPLOY_HOST:/var/www/app/
    - ssh -i ~/.ssh/deploy_key deploy@$DEPLOY_HOST 'cd /var/www/app && ./restart.sh'
  environment:
    name: production
    url: https://example.com
```

## Related Topics

- See **Environments & Deployments** for environment setup and protection
- See **Review Apps** for temporary deployment environments
