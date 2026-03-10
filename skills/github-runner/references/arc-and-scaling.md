# GitHub Actions Runner Controller (ARC) and Scaling

Deploy ephemeral, auto-scaling runners on Kubernetes using Actions Runner Controller.

---

## Actions Runner Controller Architecture

### Components

**ARC Architecture:**

- **Controller** — Kubernetes operator that manages runner lifecycle
- **Listener** — Watches GitHub for new workflow jobs, scales runners up/down
- **Runner** — Ephemeral pod that runs a single job then terminates

### Why ARC?

- **Ephemeral runners** — New runner pod per job (clean environment, security)
- **Auto-scaling** — Scale pods based on job queue depth and demand
- **Kubernetes-native** — Integrated with K8s deployments, networking, RBAC
- **Cost-efficient** — Pods only run during active jobs

---

## Prerequisites

### Kubernetes Cluster

- **Version**: Kubernetes 1.25+
- **Network**: Outbound HTTPS to GitHub (443)
- **Storage**: Optional persistent volume for build artifacts
- **RBAC**: Cluster admin permissions to install controller

### Dependencies

Install required tools:

```bash
# Install cert-manager (for webhook certificates)
kubectl apply -f https://github.com/cert-io/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# Verify cert-manager
kubectl get deployment -n cert-manager
```

### GitHub Credentials

Create a GitHub App or Personal Access Token with permissions:

**Fine-grained PAT Permissions:**

- Actions: Read and write
- Administration: Read and write (for org-level runners)
- Codespaces: Read and write
- Contents: Read and write
- Deployment: Read and write
- Environments: Read and write
- Pull requests: Read and write

---

## ARC Installation via Helm

### Add Helm Repository

```bash
# Add Actions Runner Controller Helm repo
helm repo add actions-runner-controller \
  https://actions-runner-controller.github.io/actions-runner-controller

helm repo update
```

### Install Controller

```bash
# Create namespace
kubectl create namespace actions-runner-system

# Install ARC with GitHub authentication
helm install actions-runner-controller \
  actions-runner-controller/actions-runner-controller \
  --namespace actions-runner-system \
  --set gitHubEnterpriseServerUrl="https://github.example.com" \
  --set authSecret.github_token="<GITHUB_TOKEN>" \
  --set authSecret.github_app_id="<APP_ID>" \
  --set authSecret.github_app_installation_id="<INSTALLATION_ID>" \
  --set authSecret.github_app_private_key="<PRIVATE_KEY>"
```

### Verify Installation

```bash
# Check controller pods
kubectl get pods -n actions-runner-system

# Check webhook configurations
kubectl get validatingwebhookconfigurations

# View controller logs
kubectl logs -n actions-runner-system \
  -l app.kubernetes.io/name=actions-runner-controller
```

---

## Runner Scaling Configuration

### RunnerSet Resource (ARC v2+)

Define a `RunnerSet` to manage a group of ephemeral runners:

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerSet
metadata:
  name: example-runnerset
  namespace: actions-runner-system
spec:
  replicas: 2  # Static number of pods (ignored if autoscaling enabled)

  github:
    url: "https://github.com/owner/repo"
    tokenRef:
      name: github-token  # Kubernetes secret
      key: token

  template:
    spec:
      containers:
      - name: runner
        image: ghcr.io/actions/runner:latest
        env:
        - name: RUNNER_LABELS
          value: "docker,linux,gke"
        resources:
          requests:
            cpu: "100m"
            memory: "256Mi"
          limits:
            cpu: "1000m"
            memory: "1Gi"

  # Auto-scaling configuration
  minReplicas: 1
  maxReplicas: 10
  targetWorkflowQueueLength: 5  # Scale up when queue > 5 jobs

  # Ephemeral runners (one job per pod)
  ephemeral: true

  # Pod lifecycle
  ttlSecondsAfterFinished: 300  # Keep finished pod for 5 min, then delete
```

### Webhook to Zero Scaling

Scale down to zero pods when no jobs pending:

```yaml
spec:
  minReplicas: 0  # Allow zero pods
  maxReplicas: 10

  # Webhook-based scaling (faster than polling)
  webhookEnabled: true

  # Scale up when GitHub sends webhook (job triggered)
  # Scale down after timeout with no jobs
```

---

## StatefulSet vs RunnerSet

### RunnerSet (Recommended)

For ephemeral, auto-scaling runners:

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerSet
metadata:
  name: ephemeral-runners
spec:
  ephemeral: true
  minReplicas: 0
  maxReplicas: 20
  # ... more config
```

### StatefulSet (Legacy)

For persistent runners (older ARC versions):

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: Runner
metadata:
  name: my-runner
spec:
  # ... runner config (single pod)
```

---

## Docker-in-Docker and Privileged Mode

### DinD Setup

Enable Docker-in-Docker for container image builds:

```yaml
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerSet
metadata:
  name: dind-runners
spec:
  template:
    spec:
      containers:
      - name: runner
        image: ghcr.io/actions/runner:latest
        env:
        - name: DOCKER_HOST
          value: "unix:///var/run/docker.sock"
        volumeMounts:
        - name: docker-sock
          mountPath: /var/run/docker.sock

      - name: dind
        image: docker:dind
        volumeMounts:
        - name: docker-sock
          mountPath: /var/run

      volumes:
      - name: docker-sock
        emptyDir: {}
```

### Privileged Container Alternative

Instead of DinD, run container in privileged mode:

```yaml
containers:
- name: runner
  image: ghcr.io/actions/runner:latest
  securityContext:
    privileged: true
  # ... rest of config
```

---

## Persistent Artifacts and Storage

### Ephemeral Storage (tmpfs)

Default; artifacts deleted when pod terminates:

```yaml
spec:
  template:
    spec:
      containers:
      - name: runner
        resources:
          requests:
            ephemeralStorage: "10Gi"
```

### Persistent Volume Claim

Preserve artifacts across pod lifecycle:

```yaml
spec:
  template:
    spec:
      containers:
      - name: runner
        volumeMounts:
        - name: artifacts
          mountPath: /home/runner/_work

      volumes:
      - name: artifacts
        persistentVolumeClaim:
          claimName: runner-artifacts

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: runner-artifacts
spec:
  accessModes: [ "ReadWriteOnce" ]
  resources:
    requests:
      storage: "100Gi"
```

---

## Pod Resource Management

### CPU and Memory Requests/Limits

Ensure pods have adequate resources:

```yaml
spec:
  template:
    spec:
      containers:
      - name: runner
        resources:
          requests:
            cpu: "500m"
            memory: "512Mi"
          limits:
            cpu: "2000m"
            memory: "2Gi"
```

### Horizontal Pod Autoscaler (HPA)

Alternative to built-in RunnerSet scaling:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: runner-autoscale
spec:
  scaleTargetRef:
    apiVersion: actions.summerwind.dev/v1alpha1
    kind: RunnerSet
    name: my-runners
  minReplicas: 1
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## Service Account and RBAC

### Service Account Creation

Create dedicated service account for runners:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: runner-sa
  namespace: actions-runner-system

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: runner-role
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: runner-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: runner-role
subjects:
- kind: ServiceAccount
  name: runner-sa
  namespace: actions-runner-system
```

### Use in RunnerSet

```yaml
spec:
  template:
    spec:
      serviceAccountName: runner-sa
```

---

## Secret Management

### GitHub Token Secret

Store GitHub credentials as Kubernetes secret:

```bash
# Create secret with GitHub token
kubectl create secret generic github-token \
  --from-literal=token="<GITHUB_TOKEN>" \
  -n actions-runner-system
```

Or YAML:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: github-token
  namespace: actions-runner-system
type: Opaque
stringData:
  token: "<GITHUB_TOKEN>"
```

Reference in RunnerSet:

```yaml
spec:
  github:
    tokenRef:
      name: github-token
      key: token
```

### Docker Registry Secret

For private container registries:

```bash
kubectl create secret docker-registry \
  --docker-server=registry.example.com \
  --docker-username=user \
  --docker-password=pass \
  docker-secret \
  -n actions-runner-system
```

Use in RunnerSet:

```yaml
spec:
  template:
    spec:
      imagePullSecrets:
      - name: docker-secret
```

---

## Troubleshooting ARC

### Pods Not Starting

Check pod events:

```bash
kubectl describe pod <runner-pod> -n actions-runner-system

# View pod logs
kubectl logs <runner-pod> -n actions-runner-system
```

Common issues: image not found, insufficient resources, secret not found.

### Runner Not Registering with GitHub

Verify token and GitHub connectivity:

```bash
# Check controller logs
kubectl logs -n actions-runner-system \
  -l app.kubernetes.io/name=actions-runner-controller

# Verify secret exists
kubectl get secret github-token -n actions-runner-system
```

### Scaling Not Working

Verify webhook is enabled and configured:

```bash
# Check GitHub webhook events
# In GitHub repo: Settings → Webhooks

# Check HPA status
kubectl get hpa
kubectl describe hpa runner-autoscale
```

### Persistent Artifacts Lost

Ensure PVC is properly mounted:

```bash
# Check PVC status
kubectl get pvc -n actions-runner-system

# View pod volumeMounts
kubectl get pod <runner-pod> -o yaml | grep volumeMounts
```
