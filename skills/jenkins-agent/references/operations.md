# Jenkins Agent Operations

Manage, monitor, and troubleshoot agents in production.

---

## UI Node Management

### View and Configure Agents

1. **Manage Jenkins** → **Manage Nodes and Clouds**
2. Agent list shows status (green = online, red = offline)
3. Click agent name to view/edit configuration

### Online/Offline Toggle

Temporarily take agent offline without unregistering:

1. Agent page → **Disconnect** button
2. Agent goes offline; jobs queue instead of executing
3. **Connect** to bring back online

### Wipe Agent Workspace

Clean build artifacts and workspace:

1. Agent page → **Wipe out current workspace**
2. Workspace on agent deleted; next job creates new workspace

### View Agent Logs

Troubleshoot agent issues:

1. Agent page → **System Log**
2. View agent-controller communication logs
3. Filter by log level (Info, Warning, Error)

---

## Service Control and Status

### Check Agent Status from Controller

SSH to agent and verify service:

```bash
# SSH to agent
ssh jenkins@agent.example.com

# Verify agent.jar running (JNLP)
ps aux | grep agent.jar

# Or verify systemd service (if running as service)
systemctl status jenkins-agent
journalctl -u jenkins-agent -f
```

### Take Agent Offline for Maintenance

Via UI:

1. **Manage Nodes** → Select agent
2. **Disconnect** (stop accepting jobs)
3. Wait for in-progress jobs to complete
4. Perform maintenance (updates, config changes)
5. **Connect** when ready

Via command line (graceful):

```bash
# Kill current agent.jar process; systemd restarts automatically
# Systemd will re-launch agent when maintenance done
ssh jenkins@agent.example.com "pkill -f agent.jar"
```

---

## CASC Node Configuration

Define agents as code using Jenkins Configuration as Code:

```yaml
# jenkins.yaml
jenkins:
  nodes:
  - permanent:
      name: "linux-1"
      remoteFS: "/home/jenkins"
      numExecutors: 4
      labelString: "linux docker ubuntu"
      mode: NORMAL
      launcher:
        ssh:
          host: "linux-1.example.com"
          port: 22
          credentialsId: "ssh-agent-key"
          launchTimeoutSeconds: 600
          maxNumRetries: 3
          retryWaitTime: 15
          sshHostKeyVerificationStrategy: "knownHostsFileKeyVerificationStrategy"
```

Apply via **Configure System** → **Configuration as Code**.

---

## Capacity Planning

### Executor Count and Load

Monitor agent utilization:

1. **Manage Nodes** → Agent page
2. **Load Statistics** shows:

   - Executors busy (executing jobs)
   - Queue length (jobs waiting)
   - Average queue time

### Scale Decisions

| Queue Depth | Action |
| --- | --- |
| 0-1 jobs | Adequate capacity |
| 2-5 jobs | Monitor; consider adding agents |
| 5+ jobs | Immediate action; add agents or increase executors |

### Performance Metrics

```bash
# From Jenkins API
curl http://jenkins.example.com:8080/api/xml?tree=computer[displayName,offline,executors] | grep -E '(name|offline)'

# Or from agent page → Load Statistics → Use REST API
curl 'http://jenkins.example.com:8080/computer/agent-1/api/json?pretty=true'
```

---

## Workspace Management

### Workspace Location and Structure

Agent workspace default:

```text
/home/jenkins/workspace/
├── job-name/
│   ├── .git/
│   ├── src/
│   ├── build/
│   └── artifacts/
└── another-job/
```

### Disk Usage Monitoring

Monitor agent disk space:

```bash
# On agent machine
df -h /home/jenkins/workspace

# Jenkins also tracks via UI (agent page → Disk usage)
```

### Cleanup Policies

Enable **Workspace Cleanup Plugin** for automatic cleanup:

1. **Manage Plugins** → Install `Workspace Cleanup Plugin`
2. In job configuration → **Build Environment** → Check **Delete workspace before build starts**
3. Or delete after build: **Post-build Actions** → **Workspace Cleanup**

### Manual Cleanup

```bash
# On agent machine
rm -rf /home/jenkins/workspace/old-job-name/

# Or from Jenkins UI:
# Agent page → Wipe out current workspace
```

---

## Monitoring and Metrics

### Agent Health

Monitor key health indicators:

| Metric | Source | Threshold |
| --- | --- | --- |
| **Status** | Agent page (green/red) | Always green |
| **Queue depth** | Agent page → Load Stat | < 3 jobs |
| **Avg queue time** | Agent page → Load Stat | < 5 min |
| **Disk usage** | Agent page | < 80% used |
| **Offline time** | Agent logs | Minimize |

### Prometheus Metrics (Monitoring Plugin)

Enable **Prometheus Metrics Plugin** for external monitoring:

1. **Manage Plugins** → Install `Prometheus Metrics Plugin`
2. Metrics available at: `http://jenkins.example.com:8080/prometheus/`

Key metrics for agents:

```text
jenkins_nodes_count{state="online"}  # Number of online agents
jenkins_executor_total{node="agent-1"}  # Executor count
jenkins_executor_busy{node="agent-1"}  # Busy executors
jenkins_queue_size  # Jobs in queue
```

---

## Troubleshooting

### Agent Offline After Restart

1. Check network connectivity from agent to controller:

   ```bash
   ssh jenkins@agent.example.com
   curl http://jenkins.example.com:8080/api/json
   ```

2. Verify agent service is running:

   ```bash
   systemctl status jenkins-agent
   systemctl start jenkins-agent
   ```

3. Check agent logs:

   ```bash
   journalctl -u jenkins-agent -n 50
   ```

4. Restart service if needed:

   ```bash
   systemctl restart jenkins-agent
   ```

### SSH Connection Failures

Verify SSH key and connectivity:

```bash
# From Jenkins controller
ssh -i /var/lib/jenkins/.ssh/id_rsa -v jenkins@agent.example.com whoami

# Check agent's authorized_keys
ssh -i /var/lib/jenkins/.ssh/id_rsa jenkins@agent.example.com \
  cat ~/.ssh/authorized_keys

# Verify Jenkins user on agent
ssh -i /var/lib/jenkins/.ssh/id_rsa jenkins@agent.example.com id
```

### JNLP Connection Fails

Test JNLP network connectivity:

```bash
# From agent machine
telnet jenkins.example.com 50000  # JNLP port

# Check agent logs
tail -f ~/.jnlpAgent-log.txt

# Verify secret in Jenkins UI (Node Details → JNLP Config)
# Secret must match in agent launch command
```

### Job Fails to Run on Specific Agent

Verify agent labels match job requirements:

1. **Job configuration** → **Restrict where this project can be run**
   - Check label expression (e.g., `docker && linux`)
2. **Agent node** → Verify labels assigned match
3. If labels don't match, jobs skip agent and queue forever

Example:

```groovy
// Pipeline requires docker label
pipeline {
  agent {
    label 'docker'
  }
}

// Agent must have 'docker' in its label list
// On agent page: Labels = "docker linux ubuntu"
```

### High CPU/Memory on Agent

1. Check which job is consuming resources:

   ```bash
   ps aux | grep java | head -5
   top -p <pid>  # Monitor specific process
   ```

2. Kill long-running job:
   - From Jenkins UI: Job execution page → **Stop Build**
   - Or from agent: `pkill -f build-process-name`

3. Adjust executor count if consistently high:
   - Reduce executor count to prevent job overload
   - Monitor memory and CPU before increasing

---

## Agent Decommissioning

### Remove Agent from Jenkins

1. **Manage Nodes** → Select agent
2. **Delete Node**
3. Agent removed from Jenkins

### Clean Up Agent Machine

After removing from Jenkins:

```bash
# Stop service
systemctl stop jenkins-agent
systemctl disable jenkins-agent

# Remove jenkins user and files
userdel -r jenkins
rm -rf /home/jenkins
```

---

## Auto-Connection Recovery

Configure agent to auto-reconnect on failure:

**SSH agents** (default): Auto-reconnect with exponential backoff

**JNLP agents** (default): Loop and reconnect every 10 seconds

Verify in agent logs:

```text
Trying to reconnect...
Reconnecting attempt #1
Reconnected
```

No additional config needed; Jenkins handles automatically.
