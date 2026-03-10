# OpenTofu Install & Setup

## Prerequisites

- macOS, Linux, or Windows
- 64-bit OS (arm64 or amd64)
- Network access to download providers during `tofu init`

## Install by Platform

### macOS (Homebrew)

```bash
brew install opentofu
tofu version
```

### Linux (Official Installer Script)

```bash
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh | sh
```

### Linux (apt — Debian/Ubuntu)

```bash
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/opentofu.gpg
echo "deb [signed-by=/usr/share/keyrings/opentofu.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | sudo tee /etc/apt/sources.list.d/opentofu.list
sudo apt update && sudo apt install tofu
```

### Linux (rpm — RHEL/Fedora)

```bash
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/opentofu.gpg
sudo dnf config-manager --add-repo https://packages.opentofu.org/opentofu/tofu/config_file/rpm/opentofu-tofu.repo
sudo dnf install tofu
```

### Windows

```powershell
# Winget
winget install OpenTofu.OpenTofu

# Chocolatey
choco install opentofu
```

## Version Management (tofuenv)

Manage multiple OpenTofu versions with [tofuenv](https://github.com/tofuutils/tofuenv):

```bash
# Install tofuenv (macOS/Linux)
git clone https://github.com/tofuutils/tofuenv.git ~/.tofuenv
export PATH="$HOME/.tofuenv/bin:$PATH"

# Install a specific version
tofuenv install 1.8.0
tofuenv use 1.8.0

# Pin version per project
echo "1.8.0" > .opentofu-version
```

## Running Side-by-Side with Terraform

OpenTofu (`tofu`) and Terraform (`terraform`) can coexist:

```bash
which tofu      # /usr/local/bin/tofu
which terraform # /usr/local/bin/terraform
tofu version
terraform version
```

They read the same `.tf` files but maintain separate binary state (the state file format is compatible).

## Post-Install Verification

```bash
tofu version
# Expected: OpenTofu v1.x.x

# Initialize a test directory
mkdir /tmp/tofu-test && cd /tmp/tofu-test
cat > main.tf <<'EOF'
terraform {
  required_version = ">= 1.0"
}
output "hello" { value = "ok" }
EOF
tofu init && tofu apply -auto-approve
```
