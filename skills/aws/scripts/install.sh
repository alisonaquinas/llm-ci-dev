#!/usr/bin/env bash
set -euo pipefail

# AWS CLI v2 installer for macOS, Linux

detect_platform() {
  local system=$(uname -s)
  if [[ "$system" == "Darwin" ]]; then
    echo "macos"
  elif [[ "$system" == "Linux" ]]; then
    if [[ -f /etc/os-release ]]; then
      source /etc/os-release
      echo "${ID:-linux}"
    else
      echo "linux"
    fi
  else
    echo "unknown"
  fi
}

main() {
  local platform=$(detect_platform)

  # Check if aws-cli is already installed
  if command -v aws &>/dev/null; then
    local version=$(aws --version)
    echo "[OK] $version already installed"
    echo "[HINT] Run 'references/install-and-setup.md' for post-install configuration"
    return 0
  fi

  case "$platform" in
    macos)
      echo "[INFO] Installing AWS CLI v2 on macOS via Homebrew..."
      if command -v brew &>/dev/null; then
        brew install awscli
        echo "[OK] AWS CLI installed successfully"
      else
        echo "[ERROR] Homebrew not found. Install from https://brew.sh"
        exit 1
      fi
      ;;

    debian|ubuntu|fedora|rhel|centos|arch|alpine)
      echo "[INFO] Installing AWS CLI v2 on Linux..."
      echo "[INFO] Using official AWS installer..."

      # Download and install AWS CLI v2
      local tmpdir=$(mktemp -d)
      trap "rm -rf $tmpdir" EXIT

      cd "$tmpdir"
      curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip -q awscliv2.zip
      sudo ./aws/install

      echo "[OK] AWS CLI installed successfully"
      ;;

    *)
      echo "[ERROR] Unsupported platform: $platform"
      echo "[HINT] Install manually from https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
      exit 1
      ;;
  esac

  # Verify installation
  if command -v aws &>/dev/null; then
    aws --version
    echo "[OK] Installation verified"
    echo ""
    echo "[HINT] Configure with: aws configure"
    echo "[HINT] See references/install-and-setup.md for complete setup steps"
  else
    echo "[ERROR] Installation verification failed"
    exit 1
  fi
}

main "$@"
