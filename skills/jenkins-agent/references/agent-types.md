# Jenkins Agent Types

Choose the appropriate agent launch method and architecture for your CI/CD infrastructure.

---

## Controller vs Agent Role

### Controller (Master)

- Orchestrates pipelines and schedules jobs
- Manages UI, plugins, credentials, configuration
- **Should not run build jobs** (unless explicitly configured for development)
- Provides agent management console

### Agent (Slave/Worker)

- Executes build jobs dispatched from controller
- Communicates back to controller for job assignment
- Maintains workspace for job artifacts
- Reports build status to controller

**Best practice**: Isolate workloads to agents; reserve controller for orchestration only.

---

## Agent Type Comparison

| Type | Connection | Setup | Isolation | Cost | Scaling | Best For |
| --- | --- | --- | --- | --- | --- | --- |
| **SSH** | Bidirectional SSH tunnel | Medium (SSH keys) | Medium | Low (existing infra) | Manual | Existing Unix/Linux servers |
| **JNLP** | Agent initiates outbound connection | Low (URL + token) | Medium | Low | Manual | Testing, firewall traversal |
| **WebSocket JNLP** | Agent outbound WebSocket (port 443) | Medium (certificate) | Medium | Low | Manual | HTTPS-only environments |
| **Docker Cloud** | Docker plugin provisions & manages | High (Docker config) | High (containers) | Medium | Automatic | On-demand Docker agents |
| **Kubernetes** | K8s plugin manages pod lifecycle | High (K8s manifest) | High (pods) | Medium | Automatic | Cloud-native, K8s clusters |
| **Built-in (No-op)** | Runs on controller | None | None | Free | No | Dev/testing only |

---

## SSH Launch Agent

Execute commands on remote Unix/Linux machine via SSH.

### Prerequisites

- Linux/Unix remote machine with Java installed
- SSH access with key-based authentication
- Network connectivity from controller to agent port 22

### Configuration in UI

1. **Jenkins Manage Nodes** → **New Node**
2. **Name**: Agent identifier
3. **Executor Count**: Number of concurrent jobs (usually 2-4)
4. **Remote Root Directory**: Workspace path on agent (e.g., `/home/jenkins`)
5. **Labels**: Tags for job matching (e.g., `linux`, `docker`)
6. **Launch Method**: **SSH Launch**
   - **Host**: IP or hostname of agent
   - **Credentials**: SSH key pair (username + private key)
   - **Host Key Verification**: `Known Hosts Checking`

### SSH Agent Setup

On remote machine:

```bash
# Create jenkins user
sudo useradd -m -s /bin/bash jenkins

# Create SSH directory
sudo mkdir -p /home/jenkins/.ssh
sudo chmod 700 /home/jenkins/.ssh

# Add Jenkins controller public key to authorized_keys
# (Obtain public key from Jenkins UI)
echo "ssh-rsa AAAA..." | sudo tee -a /home/jenkins/.ssh/authorized_keys
sudo chmod 600 /home/jenkins/.ssh/authorized_keys
sudo chown -R jenkins:jenkins /home/jenkins/.ssh

# Install Java
sudo apt-get update && sudo apt-get install -y openjdk-11-jdk

# Create workspace
sudo mkdir -p /home/jenkins/workspace
sudo chown jenkins:jenkins /home/jenkins/workspace
```

### Credentials Management

Store SSH private key as Jenkins credential:

1. **Jenkins** → **Manage Credentials**
2. **Global** → **Add Credentials**
3. **Kind**: SSH Username with Private Key
4. **ID**: `ssh-agent-key`
5. **Username**: `jenkins` (or remote user)
6. **Private Key**: Paste or upload private key file

Then reference in SSH agent node configuration.

---

## JNLP Launch Agent

Agent initiates outbound connection to controller via Java Network Launch Protocol.

### Prerequisites

- Remote machine with Java installed
- Network connectivity from agent to controller port 50000 (or custom)
- Pre-shared agent secret/token

### Configuration in UI

1. **Jenkins Manage Nodes** → **New Node**
2. **Name**: Agent identifier
3. **Launch Method**: **Launch agent via JNLP**
4. **JNLP URL**: Auto-generated (`http://jenkins.example.com:8080/computer/<AGENT_NAME>/slave-agent.jnlp`)
5. **Credentials**: Create or select agent credentials

### JNLP Agent Launch

Download and run agent.jar:

```bash
# Create directory
mkdir -p ~/jenkins-agent && cd ~/jenkins-agent

# Download agent.jar from controller
curl http://jenkins.example.com:8080/jnlpJars/agent.jar -o agent.jar

# Launch agent (blocking)
java -jar agent.jar -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp -secret <SECRET>
```

Obtain secret from Jenkins UI: **Node Details** → **JNLP Config** → Copy Secret.

### JNLP as Systemd Service

Wrap JNLP agent in systemd for persistent operation:

```ini
# /etc/systemd/system/jenkins-agent.service
[Unit]
Description=Jenkins JNLP Agent
After=network.target

[Service]
Type=simple
User=jenkins
WorkingDirectory=/home/jenkins/agent
ExecStart=/usr/bin/java -jar agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp \
  -secret <SECRET>
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable jenkins-agent
sudo systemctl start jenkins-agent
```

### WebSocket JNLP (Firewall Traversal)

For networks requiring HTTPS-only connectivity, use WebSocket JNLP:

```bash
java -jar agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp \
  -secret <SECRET> \
  -webSocket \
  -Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false
```

Or configure in Jenkins UI: **Manage Jenkins** → **Configure System** → **JNLP** → **Enable WebSocket**.

---

## Docker Cloud Agent

Dynamic agent provisioning via Docker daemon; Jenkins creates container per job.

### Prerequisites

- Docker daemon running on dedicated machine or swarm
- Docker plugin installed on Jenkins (`Manage Plugins` → `Docker`)
- Network connectivity from Jenkins to Docker host (port 2375 or 2376 for TLS)

### Docker Cloud Configuration

In Jenkins **Manage Jenkins** → **Configure System** → **Cloud**:

1. **Add New Cloud** → **Docker**
2. **Docker Host URI**: `tcp://docker.example.com:2375` or Unix socket
3. **Credentials**: If TLS required, upload CA cert, client cert, client key
4. **Test Connection** to verify

### Docker Agent Template

Define Docker image and container settings:

1. In Docker Cloud config, **Add Agent Template**:
   - **Docker Image**: `jenkins/inbound-agent` or custom image
   - **Instance Cap**: Max containers (e.g., 5)
   - **Remote FS Root**: `/home/jenkins` (workspace mount)
   - **Labels**: `docker`, `linux` (for job matching)
   - **Pull Strategy**: `Pull once and update latest`
   - **Environment**: Pass env vars to container
   - **Volumes**: Bind mounts (e.g., `/var/run/docker.sock:/var/run/docker.sock`)

### Docker Image

Use official `jenkins/inbound-agent` or build custom:

```dockerfile
FROM jenkins/inbound-agent:latest
RUN apt-get update && apt-get install -y \
    docker.io \
    postgresql-client \
    redis-tools
```

Build and push:

```bash
docker build -t myregistry/jenkins-agent:1.0 .
docker push myregistry/jenkins-agent:1.0
```

---

## Kubernetes Agent (Kubernetes Plugin)

Provision pods as dynamic agents; Jenkins creates pod per job.

### Prerequisites

- Kubernetes cluster (1.16+)
- `kubernetes-plugin` installed on Jenkins
- Service account and RBAC configured

### Kubernetes Cloud Configuration

In Jenkins **Manage Jenkins** → **Configure System** → **Cloud**:

1. **Add New Cloud** → **Kubernetes**
2. **Kubernetes URL**: `https://kubernetes.example.com` (or `https://kubernetes.default.svc.cluster.local` if Jenkins in K8s)
3. **Kubernetes Credentials**: Paste kubeconfig or service account token
4. **Kubernetes Namespace**: `jenkins` (or your namespace)
5. **Test Connection** to verify

### Pod Template

Define pod specifications for agents:

1. **Add Pod Template**:
   - **Name**: `default`
   - **Namespace**: `jenkins`
   - **Labels**: `kubernetes`, `linux` (for job matching)
   - **Usage**: `Use this node as much as possible`
   - **Containers**: Add container
     - **Docker Image**: `jenkins/inbound-agent:latest`
     - **Run in privileged mode**: (optional, for Docker builds)
     - **CPU Request/Limit**: `100m` / `1000m`
     - **Memory Request/Limit**: `256Mi` / `1024Mi`

### Pod Manifest (YAML)

Pod template can be configured via YAML:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: agent
spec:
  serviceAccountName: jenkins
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    env:
    - name: JENKINS_URL
      value: "http://jenkins.example.com:8080"
    resources:
      requests:
        memory: "256Mi"
        cpu: "100m"
      limits:
        memory: "1Gi"
        cpu: "1000m"
  - name: dind
    image: docker:dind
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-sock
    emptyDir: {}
```

---

## Built-in Agent

Runs builds on the Jenkins controller itself (not recommended).

### Use Cases

- Development/testing only
- Single-node setups (temporary)
- No production use

### Configuration

Builds automatically use built-in agent when labeled `master` or if no agents available.

**To restrict**: Set `# of executors = 0` on built-in agent to disable all jobs.

---

## Executor Count

Control concurrency per agent:

| Executor Count | Use Case | Load |
| --- | --- | --- |
| 1 | Single long-running job per agent | Low CPU, high memory |
| 2-4 | Small shared servers, parallel small jobs | Balanced |
| 8+ | High-CPU machines, many small jobs | High concurrency |

Calculate recommended count:

```text
Executors = (Physical CPU Cores - 1) / 2

Example: 16-core machine
Executors = (16 - 1) / 2 = 7-8 recommended
```

---

## Connecting Multiple Agent Types

Mix agent types in single Jenkins instance:

```text
Jenkins Controller
├── SSH Agent (linux-1)
├── SSH Agent (linux-2)
├── JNLP Agent (windows-1)
├── Docker Cloud (dynamic, 0-5 containers)
└── Kubernetes (dynamic, 0-20 pods)
```

Jobs specify required agent type via labels:

```groovy
pipeline {
  agent {
    label 'docker'  // Matches Docker Cloud or Kubernetes agents
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build .'
      }
    }
  }
}
```
