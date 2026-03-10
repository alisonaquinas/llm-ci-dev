# Jenkins Cloud and Dynamic Agents

Configure Docker Cloud and Kubernetes plugin for dynamic agent provisioning.

---

## Docker Cloud Plugin

Dynamically provision Docker containers as Jenkins agents.

### Installation and Configuration

1. **Manage Plugins** → Search `Docker Pipeline`
2. **Install without restart**
3. **Manage Jenkins** → **Configure System**
4. **Cloud** → **Add a new cloud** → **Docker**

### Docker Cloud Settings

| Setting | Value | Example |
| --- | --- | --- |
| **Name** | Cloud identifier | `docker-cloud` |
| **Docker Host URI** | Docker daemon connection | `tcp://docker.example.com:2375` or `unix:///var/run/docker.sock` |
| **Server Certificate Verification** | TLS config (if using TLS) | Upload CA, client cert, client key |
| **Container Cap** | Max total containers | `10` |
| **Read Timeout** | Docker API timeout (ms) | `60` |

### Docker Agent Template

Define container specifications:

1. **Docker Cloud** → **Add Agent Template**
2. **Docker Image**: `jenkins/inbound-agent:latest` or custom image
3. **Pull Strategy**: `Pull latest image`
4. **Instance Cap**: Max containers from this template (`5`)
5. **Remote FS Root**: `/home/jenkins` (workspace mount)
6. **Instance Creation Timeout**: `600` seconds
7. **Labels**: `docker`, `linux`, `ubuntu` (for job matching)
8. **Connect Method**: `Attach Docker container` (recommended)
9. **Bind All Ports**: Unchecked
10. **Privileged Mode**: Checked (if Docker-in-Docker needed)
11. **Port Binding**: Leave empty (auto-assign)
12. **Environment**:
    - `JENKINS_URL=http://jenkins.example.com:8080`
    - `JENKINS_AGENT_WORKDIR=/home/jenkins`
13. **Volumes**: Bind mounts
    - `/var/run/docker.sock:/var/run/docker.sock` (for Docker-in-Docker)
14. **Network**: `bridge`
15. **Run user**: Leave empty (container default)

### Custom Docker Image for Agents

Build image with pre-installed tools:

```dockerfile
FROM jenkins/inbound-agent:latest

# Install tools
RUN apt-get update && apt-get install -y \
    docker.io \
    postgresql-client \
    redis-tools \
    git \
    curl \
    jq

# Set working directory
WORKDIR /home/jenkins
```

Build and push:

```bash
docker build -t myorg/jenkins-agent:1.0 .
docker push myorg/jenkins-agent:1.0

# Update Docker Cloud template to use: myorg/jenkins-agent:1.0
```

### Job Configuration for Docker Cloud

In Declarative Pipeline, target Docker agents:

```groovy
pipeline {
  agent {
    label 'docker'  // Matches docker cloud agents
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t myapp:latest .'
        sh 'docker run --rm myapp:latest npm test'
      }
    }
  }
}
```

### Docker Cloud Operations

Monitor running containers:

```bash
# List Jenkins-created containers
docker ps | grep -i jenkins

# Inspect container
docker inspect <container-id>

# View logs
docker logs <container-id>

# Stop container (Jenkins auto-removes after job)
docker stop <container-id>
```

---

## Kubernetes Plugin

Dynamically provision Kubernetes pods as Jenkins agents.

### Installation and Prerequisites

1. **Manage Plugins** → Search `Kubernetes`
2. **Install without restart**
3. Kubernetes cluster accessible from Jenkins
4. Service account with agent pod creation permissions

### Kubernetes Cloud Configuration

1. **Manage Jenkins** → **Configure System**
2. **Cloud** → **Add a new cloud** → **Kubernetes**
3. **Kubernetes URL**: Cluster API endpoint
   - Auto-detect if Jenkins running in cluster: `https://kubernetes.default.svc.cluster.local`
   - External cluster: `https://cluster.example.com`
4. **Kubernetes Credentials**: Service account token or kubeconfig
5. **Kubernetes Namespace**: `jenkins` (or your namespace)
6. **Jenkins URL**: `http://jenkins:8080` (internal K8s DNS)
7. **Jenkins Tunnel**: `jenkins:50000` (for JNLP connection)
8. **Test Connection** → Should show `Connected`

### Pod Template Configuration

Define pod specs:

1. **Pod Templates** → **Add Pod Template**
2. **Name**: `default`
3. **Namespace**: `jenkins`
4. **Labels**: `kubernetes`, `linux` (for job matching)
5. **Usage**: `Use this node as much as possible`
6. **Containers** → **Add Container**
   - **Image**: `jenkins/inbound-agent:latest`
   - **Run command**: (leave empty; defaults to JNLP)
   - **Args**: (leave empty)
   - **Allocate pseudo-TTY**: Checked
7. **Resource Limit**:
   - **CPU**: `1000m`
   - **Memory**: `1024Mi`
8. **Resource Request**:
   - **CPU**: `100m`
   - **Memory**: `256Mi`
9. **Node Selector**: (if restricting to specific nodes; optional)
10. **Service Account**: `jenkins` (must be created; see RBAC section)
11. **Privileged Mode**: Checked (if Docker-in-Docker needed)
12. **Run as UID**: (leave empty for container default)

### Pod Template (YAML Alternative)

Advanced users can define pod template as YAML:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: agent
  namespace: jenkins
spec:
  serviceAccountName: jenkins
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    imagePullPolicy: IfNotPresent
    env:
    - name: JENKINS_URL
      value: "http://jenkins:8080"
    - name: JENKINS_AGENT_WORKDIR
      value: "/home/jenkins/agent"
    resources:
      requests:
        memory: "256Mi"
        cpu: "100m"
      limits:
        memory: "1Gi"
        cpu: "1000m"
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  - name: docker
    image: docker:dind
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run
  volumes:
  - name: docker-sock
    emptyDir: {}
  restartPolicy: Never
  nodeSelector:
    disk: ssd  # Run on SSD nodes only (example)
```

Paste this in Jenkins **Pod Template** → **YAML Configuration**.

### RBAC: Service Account and Permissions

Create service account for Jenkins pod creation:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: jenkins

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: jenkins
rules:
- apiGroups: [""]
  resources: ["pods", "pods/logs", "pods/exec", "events"]
  verbs: ["get", "list", "watch", "create", "delete"]
- apiGroups: [""]
  resources: ["persistentvolumeclaims"]
  verbs: ["get", "list", "create", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: jenkins
subjects:
- kind: ServiceAccount
  name: jenkins
  namespace: jenkins
```

Apply:

```bash
kubectl apply -f jenkins-rbac.yaml
kubectl get sa jenkins -n jenkins  # Verify
```

### Job Configuration for Kubernetes

Target Kubernetes agents in pipeline:

```groovy
pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            jenkins: agent
        spec:
          containers:
          - name: docker
            image: docker:dind
            securityContext:
              privileged: true
      '''
    }
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t myapp:latest .'
      }
    }
  }
}
```

### Pod Retention and Cleanup

Control pod lifecycle:

1. **Pod Templates** → **Pod Retention**
   - **Never**: Delete immediately after job
   - **OnFailure**: Keep failed pods for debugging
   - **Always**: Keep all pods (not recommended)

2. **TTL After Finished**: Auto-delete after N seconds (K8s 1.23+)

### Kubernetes Operations

Monitor pods:

```bash
# List Jenkins pods
kubectl get pods -n jenkins | grep jenkins

# View pod logs
kubectl logs -n jenkins <pod-name>

# Describe pod (debug info)
kubectl describe pod <pod-name> -n jenkins

# Delete stuck pod
kubectl delete pod <pod-name> -n jenkins
```

---

## CASC: Configuration as Code

Define agents in `jenkins.yaml` for infrastructure-as-code approach.

### CASC Pod Template Example

```yaml
# jenkins.yaml
jenkins:
  clouds:
  - kubernetes:
      name: "kubernetes"
      serverUrl: "https://kubernetes.default.svc.cluster.local"
      credentialsId: "k8s-service-account"
      namespace: "jenkins"
      jenkinsUrl: "http://jenkins:8080"
      jenkinsTunnel: "jenkins:50000"
      templates:
      - name: "default"
        namespace: "jenkins"
        labels: "kubernetes linux"
        containers:
        - name: "jnlp"
          image: "jenkins/inbound-agent:latest"
          resourceRequests:
            memory: "256Mi"
            cpu: "100m"
          resourceLimits:
            memory: "1Gi"
            cpu: "1000m"
        podRetention: "never"
```

Apply via Jenkins **Configure System** → **Configuration as Code** → Paste YAML.

---

## Troubleshooting Cloud Agents

### Docker Cloud Container Fails to Start

```bash
# Check Docker daemon
docker ps

# Verify Jenkins can connect to Docker
curl http://docker.example.com:2375/_ping  # Should return OK

# View Jenkins logs for Docker errors
tail -f $JENKINS_HOME/logs/agents.log
```

### Kubernetes Pod Never Starts

```bash
# Check pod creation
kubectl get pods -n jenkins | grep jenkins

# Describe failed pod
kubectl describe pod <pod-name> -n jenkins

# Common issues:
# - Image pull failures: kubectl describe pod <pod> → Events section
# - RBAC permissions: kubectl auth can-i create pods -n jenkins
# - Resource constraints: kubectl top nodes
```

### Persistent Volume Claim Fails

```bash
# Check PVC status
kubectl get pvc -n jenkins

# Describe PVC
kubectl describe pvc <pvc-name> -n jenkins

# View available storage classes
kubectl get storageclass
```
