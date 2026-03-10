---
name: jenkins-agent
description: >
  Install, connect, configure, and maintain Jenkins agents and nodes.
  Cover static SSH and JNLP agents, Docker cloud agents, Kubernetes plugin pods, agent registration, and operational management.
---

# Jenkins Agent

Install and manage Jenkins agents (also called nodes) to distribute job execution across infrastructure.
This skill covers static SSH and JNLP agents, Docker cloud agents, Kubernetes plugin pods, and operational management.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Agent Types | `references/agent-types.md` | Choosing between SSH, JNLP, Docker, Kubernetes, or built-in agents |
| Installation & Connection | `references/installation-and-connection.md` | Installing agent.jar, configuring SSH keys, JNLP launch, Windows agents |
| Cloud & Dynamic Agents | `references/cloud-and-dynamic-agents.md` | Docker Cloud plugin, Kubernetes plugin, pod templates, CASC |
| Operations | `references/operations.md` | UI management, service control, capacity planning, troubleshooting |

---

## Quick Start

### Core Concepts

Jenkins **controller** (master) orchestrates CI pipelines; **agents** (workers) execute jobs on distributed infrastructure.
Builds should never run on the controller; agents isolate workloads, prevent controller overload, and scale to demand.

### Agent Anatomy

Key properties for any Jenkins agent:

| Property | Purpose | Example |
| --- | --- | --- |
| **Name** | Display identifier | `builder-1`, `macos-xcode-15` |
| **URL** | Jenkins instance URL (controller to contact) | `http://jenkins.example.com:8080` |
| **Root Directory** | Workspace location on agent | `/home/jenkins/workspace` |
| **Labels** | Tags for job-to-agent matching | `linux`, `docker`, `gpu`, `production` |
| **Executor Count** | Concurrent jobs per agent | 2 to 8 (depends on CPU) |
| **Launch Method** | How agent connects to controller | SSH, JNLP, Docker, Kubernetes |
| **Credentials** | Auth to controller or remote machine | SSH key, auth token, managed credentials |

### Minimal JNLP Agent Quick Start

Launch an agent via JNLP (Java Network Launch Protocol) for quick testing:

```bash
# Download agent.jar from controller
curl http://jenkins.example.com:8080/jnlpJars/agent.jar -o agent.jar

# Launch agent
java -jar agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp \
  -secret <SECRET_TOKEN>
```

For persistent operation, wrap in systemd service or container.

---

## Cross-References

Use alongside these skills for deeper context:

- **jenkins-ci** — Write and maintain Declarative Pipelines that target specific agents
- **jenkins-docs** — Deep syntax reference for Jenkins Declarative Pipeline and agent directives
- **ci-architecture** — Design patterns for multi-agent deployments, labeling strategies, and resource allocation

---

## Related References

- Load **Agent Types** to understand SSH, JNLP, Docker, and Kubernetes agent options
- Load **Installation & Connection** for step-by-step agent setup and secret/credential management
- Load **Cloud & Dynamic Agents** for Docker Cloud plugin and Kubernetes pod templates
- Load **Operations** for node management, monitoring, and troubleshooting in production
