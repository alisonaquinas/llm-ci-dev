# Jenkins Agent Installation and Connection

Install and configure agent.jar, SSH setup, JNLP launch, and Windows agents.

---

## agent.jar Download and Verification

### Download from Jenkins Controller

```bash
# Download agent.jar
curl http://jenkins.example.com:8080/jnlpJars/agent.jar -o agent.jar

# Or using wget
wget http://jenkins.example.com:8080/jnlpJars/agent.jar

# Verify file
file agent.jar  # Should be "Java archive data"
java -jar agent.jar --version  # Display version
```

### agent.jar Checksums

Verify download integrity:

```bash
# Jenkins provides checksums on releases page
curl -L https://github.com/jenkinsci/remoting/releases | grep -o 'agent-.*\.jar'

# Verify with SHA256
sha256sum agent.jar
```

### agent.jar vs slave.jar

- **agent.jar** (current) — Modern agent binary, includes remoting library
- **slave.jar** (deprecated) — Legacy name; no longer recommended

Use `agent.jar` for all new agent deployments.

---

## SSH Agent Setup

### Prerequisites

Generate SSH key pair on Jenkins controller:

```bash
# As Jenkins user
sudo -u jenkins ssh-keygen -t rsa -N "" -f /var/lib/jenkins/.ssh/id_rsa -C "jenkins@controller"

# Copy public key
sudo cat /var/lib/jenkins/.ssh/id_rsa.pub
```

### Configure Remote SSH Host

On agent machine:

```bash
# Create jenkins user
sudo useradd -m -s /bin/bash jenkins

# Create SSH directory
sudo mkdir -p /home/jenkins/.ssh
sudo chmod 700 /home/jenkins/.ssh

# Add Jenkins controller public key
# Paste the output from above command
echo "ssh-rsa AAAA..." | sudo tee /home/jenkins/.ssh/authorized_keys
sudo chmod 600 /home/jenkins/.ssh/authorized_keys
sudo chown -R jenkins:jenkins /home/jenkins

# Verify SSH key-based login works (from controller)
ssh -i /var/lib/jenkins/.ssh/id_rsa jenkins@agent-host whoami
```

### SSH Agent Node in Jenkins UI

1. **Manage Nodes** → **New Node**
2. **Node name**: `agent-linux-1`
3. **Type**: Permanent Agent
4. **Description**: SSH agent for Linux builds
5. **Number of executors**: `4`
6. **Remote root directory**: `/home/jenkins`
7. **Labels**: `linux`, `docker`, `ubuntu`
8. **Launch method**: **SSH Launch**
   - **Host**: IP address or hostname
   - **Credentials**: Create SSH credential (username: `jenkins`, private key from controller)
   - **Host Key Verification**: `Known Hosts Checking` (after first connection)
9. **Save**

Jenkins will SSH to agent, download agent.jar, and establish connection.

### SSH Credential in Jenkins

1. **Manage Credentials** → **System** → **Global Credentials**
2. **Add Credentials**
3. **Kind**: SSH Username with Private Key
4. **Scope**: Global
5. **ID**: `ssh-agent-key`
6. **Username**: `jenkins`
7. **Private Key**: Paste private key (from `/var/lib/jenkins/.ssh/id_rsa`)
8. **Passphrase**: (leave empty if no passphrase)
9. **Create**

Reference by ID in SSH node configuration.

---

## JNLP Agent Launch

### Generate Agent Secret

1. **Manage Nodes** → **New Node**
2. **Node name**: `agent-jnlp-1`
3. **Launch method**: **Launch agent via JNLP**
4. **Save** (Jenkins auto-generates JNLP URL and secret)
5. **Node Details** → Copy secret from **JNLP Config** section

### Launch JNLP Agent Manually

```bash
# Create agent directory
mkdir -p ~/jenkins-agent && cd ~/jenkins-agent

# Download agent.jar from controller
curl http://jenkins.example.com:8080/jnlpJars/agent.jar -o agent.jar

# Launch agent (blocking in foreground)
java -jar agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-jnlp-1/slave-agent.jnlp \
  -secret <SECRET_FROM_UI>

# Or with NoCache to prevent caching issues
java -jar agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-jnlp-1/slave-agent.jnlp \
  -secret <SECRET> \
  -noCertificateCheck  # For self-signed certs
```

### JNLP Agent as Systemd Service

Create persistent service:

```ini
# /etc/systemd/system/jenkins-agent.service
[Unit]
Description=Jenkins JNLP Agent
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=jenkins
Group=jenkins
WorkingDirectory=/home/jenkins/agent
ExecStart=/usr/bin/java -jar /home/jenkins/agent/agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-jnlp-1/slave-agent.jnlp \
  -secret <SECRET>
Restart=always
RestartSec=15s
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable jenkins-agent
sudo systemctl start jenkins-agent
sudo systemctl status jenkins-agent
```

### JNLP Agent as Docker Container

```bash
docker run -d \
  --name jenkins-agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/inbound-agent:latest \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp \
  -secret <SECRET>
```

---

## WebSocket JNLP (HTTPS-Only Networks)

For networks where outbound TCP is restricted to HTTPS (port 443):

### Enable WebSocket on Jenkins Controller

1. **Manage Jenkins** → **Configure System**
2. **JNLP** section → **Enable WebSocket**
3. **Save**

### Launch WebSocket Agent

```bash
java -jar agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp \
  -secret <SECRET> \
  -webSocket
```

Or set environment variable:

```bash
export JENKINS_WEBSOCKET=true
java -jar agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp \
  -secret <SECRET>
```

---

## Windows Agent Setup

### Prerequisites

- Windows Server 2016+ (or Windows 10+)
- Java installed (`choco install openjdk11` or manual)
- Network connectivity to Jenkins controller

### Download and Setup

```powershell
# Create agent directory
mkdir $env:PROGRAMFILES\Jenkins
cd $env:PROGRAMFILES\Jenkins

# Download agent.jar
Invoke-WebRequest -Uri "http://jenkins.example.com:8080/jnlpJars/agent.jar" -OutFile "agent.jar"

# Download agent.exe wrapper
Invoke-WebRequest -Uri "http://jenkins.example.com:8080/jnlpJars/agent.exe" -OutFile "agent.exe"
```

### Register as Windows Service

```powershell
# From admin PowerShell in agent directory

# Install service
.\agent.exe install
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp \
  -secret <SECRET> \
  -workDir "$env:PROGRAMFILES\Jenkins"

# Start service
Start-Service Jenkins-Agent

# Check status
Get-Service Jenkins-Agent
```

### Troubleshoot Windows Service

```powershell
# View service status
Get-Service Jenkins-Agent | Format-List

# View service logs (Event Viewer)
Get-EventLog -LogName Application | Where-Object { $_.Source -eq "Jenkins Agent" }

# Restart service
Restart-Service Jenkins-Agent

# Remove service (if needed)
.\agent.exe stop
.\agent.exe uninstall
```

---

## macOS Agent Installation (JNLP)

### Prerequisites

- macOS 10.15+ (Monterey, Ventura, Sonoma, etc.)
- Java installed (`brew install openjdk@11` or `openjdk@17`)
- Jenkins controller accessible from network

### Install as Launch Agent

```bash
# Create agent directory
mkdir -p ~/jenkins-agent && cd ~/jenkins-agent

# Download agent.jar
curl http://jenkins.example.com:8080/jnlpJars/agent.jar -o agent.jar

# Create launch agent plist
cat > ~/Library/LaunchAgents/com.jenkins.agent.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.jenkins.agent</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/java</string>
    <string>-jar</string>
    <string>/Users/$(whoami)/jenkins-agent/agent.jar</string>
    <string>-jnlpUrl</string>
    <string>http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp</string>
    <string>-secret</string>
    <string><SECRET></string>
  </array>
  <key>WorkingDirectory</key>
  <string>/Users/$(whoami)/jenkins-agent</string>
  <key>StandardOutPath</key>
  <string>/Users/$(whoami)/Library/Logs/jenkins-agent.log</string>
  <key>StandardErrorPath</key>
  <string>/Users/$(whoami)/Library/Logs/jenkins-agent-error.log</string>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
</dict>
</plist>
EOF

# Load launch agent
launchctl load ~/Library/LaunchAgents/com.jenkins.agent.plist

# Verify
launchctl list | grep jenkins
```

### Manage macOS Launch Agent

```bash
# Start service
launchctl start com.jenkins.agent

# Stop service
launchctl stop com.jenkins.agent

# View logs
tail -f ~/Library/Logs/jenkins-agent.log
tail -f ~/Library/Logs/jenkins-agent-error.log

# Unload (disable auto-start)
launchctl unload ~/Library/LaunchAgents/com.jenkins.agent.plist

# Remove service
launchctl unload ~/Library/LaunchAgents/com.jenkins.agent.plist
rm ~/Library/LaunchAgents/com.jenkins.agent.plist
```

### macOS SSH Agent Setup

For SSH-based agent on macOS:

```bash
# Create jenkins user
sudo dscl . -create /Users/jenkins

# Generate SSH keys
sudo -u jenkins ssh-keygen -t rsa -N "" -f /Users/jenkins/.ssh/id_rsa

# In Jenkins UI, add as SSH agent:
# - Host: <macOS-hostname>.local
# - Credentials: SSH key from above
# - Remote Root: /Users/jenkins/workspace
```

---

## Windows Subsystem for Linux 2 (WSL2) Agent Installation

Run Jenkins agents natively on WSL2 using Linux binaries:

### Prerequisites

- WSL2 with Ubuntu 20.04 LTS or later
- Java installed (`sudo apt-get install openjdk-11-jdk`)
- Jenkins controller accessible from Windows/WSL2 network

### JNLP Agent on WSL2

```bash
# Inside WSL2 terminal
mkdir -p ~/jenkins-agent && cd ~/jenkins-agent

# Download agent.jar
curl http://jenkins.example.com:8080/jnlpJars/agent.jar -o agent.jar

# Create systemd service for WSL2
sudo tee /etc/systemd/system/jenkins-agent.service > /dev/null <<'EOF'
[Unit]
Description=Jenkins JNLP Agent (WSL2)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$USER
WorkingDirectory=/home/$USER/jenkins-agent
ExecStart=/usr/bin/java -jar /home/$USER/jenkins-agent/agent.jar \
  -jnlpUrl http://jenkins.example.com:8080/computer/agent-1/slave-agent.jnlp \
  -secret <SECRET>
Restart=always
RestartSec=15s

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable jenkins-agent
sudo systemctl start jenkins-agent
```

### Docker Cloud Agent from WSL2

Access Docker Desktop daemon from WSL2:

```bash
# Verify Docker connectivity (Docker Desktop must be running)
docker ps

# In Jenkins UI, configure Docker Cloud to use WSL2 host
# - Docker Host URI: tcp://localhost:2375 (Docker Desktop exposes on localhost)
# - Agent template can use wsl2 label
```

### SSH Agent on WSL2

```bash
# Create jenkins user in WSL2
sudo useradd -m -s /bin/bash jenkins

# Generate SSH keys
sudo -u jenkins ssh-keygen -t rsa -N "" -f /home/jenkins/.ssh/id_rsa

# Get WSL2 IP
ip addr show eth0 | grep "inet " | awk '{print $2}' | cut -d/ -f1

# In Jenkins UI, add SSH agent:
# - Host: <WSL2-IP> (from command above)
# - Credentials: SSH key from /home/jenkins/.ssh/id_rsa
# - Remote Root: /home/jenkins/workspace
```

### WSL2 Jenkins Workspace Notes

- Use `/home/jenkins/workspace` (Linux filesystem) for best I/O performance
- Avoid `/mnt/c/` paths (Windows filesystem slower via WSL2 bridge)
- Build artifacts in Linux filesystem, then copy to Windows if needed

---

## agent.jar Command-Line Options

### Common Options

| Option | Purpose |
| --- | --- |
| `-jnlpUrl <URL>` | JNLP connection URL (required for JNLP agents) |
| `-secret <TOKEN>` | Agent secret token |
| `-workDir <DIR>` | Workspace directory (default: current) |
| `-webSocket` | Use WebSocket instead of TCP |
| `-noCertificateCheck` | Skip SSL certificate validation (insecure) |
| `-noReconnect` | Exit if disconnected (default: reconnect) |

### Full Usage

```bash
java -jar agent.jar --help
```

---

## Verify Agent Connection

### From Jenkins UI

1. **Manage Nodes**
2. Agent should show **Online** and green checkmark
3. **Agent Details** → **Log** shows connection messages

### From Agent Machine

```bash
# Check if agent.jar is running
ps aux | grep agent.jar

# Verify network connectivity to Jenkins
nc -zv jenkins.example.com 50000  # Default JNLP port

# Check agent logs
tail -f /home/jenkins/.jnlpAgent-log.txt  # JNLP logs (varies by OS)
```

---

## Troubleshooting Agent Connection

### SSH Agent Connection Fails

```bash
# Verify SSH key is working
ssh -i /var/lib/jenkins/.ssh/id_rsa jenkins@agent-host whoami

# Check Jenkins SSH connectivity logs
# In Jenkins UI: Node Details → System Log

# Common issues:
# - SSH key not in authorized_keys
# - Wrong username
# - Firewall blocking port 22
```

### JNLP Agent Connection Fails

```bash
# Verify network connectivity
curl http://jenkins.example.com:8080/api/json

# Check JNLP port (default 50000)
telnet jenkins.example.com 50000

# Verify secret is correct (from Node Details page)

# Common issues:
# - Firewall blocking port 50000
# - Secret expired or incorrect
# - Jenkins URL is wrong
```

### agent.jar Crashes on Start

```bash
# Increase Java heap size
java -Xmx512m -jar agent.jar -jnlpUrl ...

# Run with debug output
java -jar agent.jar -jnlpUrl ... -debug

# Check Java version
java -version
```
