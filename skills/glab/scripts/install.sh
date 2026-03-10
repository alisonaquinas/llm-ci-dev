#!/usr/bin/env bash
set -euo pipefail

# GitLab CLI (glab) installer for macOS, Linux

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

  # Check if glab is already installed
  if command -v glab &>/dev/null; then
    local version=$(glab --version)
    echo "[OK] $version already installed"
    echo "[HINT] Run 'references/install-and-setup.md' for post-install configuration"
    return 0
  fi

  case "$platform" in
    macos)
      echo "[INFO] Installing GitLab CLI on macOS via Homebrew..."
      if command -v brew &>/dev/null; then
        brew install glab
        echo "[OK] glab installed successfully"
      else
        echo "[ERROR] Homebrew not found. Install from https://brew.sh"
        exit 1
      fi
      ;;

    debian|ubuntu)
      echo "[INFO] Installing GitLab CLI on Debian/Ubuntu..."
      echo "[INFO] Adding GitLab apt repository..."

      curl -s https://repo.gitlab.com/api/v4/projects/gitlab-org%2Fglabcli/packages/debian/distributions | sudo bash
      sudo apt update
      sudo apt install -y glab
      echo "[OK] glab installed successfully"
      ;;

    fedora|rhel|centos)
      echo "[INFO] Installing GitLab CLI on Fedora/RHEL..."
      sudo dnf install -y glab
      echo "[OK] glab installed successfully"
      ;;

    arch)
      echo "[INFO] Installing GitLab CLI on Arch Linux..."
      sudo pacman -S --noconfirm glab
      echo "[OK] glab installed successfully"
      ;;

    *)
      echo "[ERROR] Unsupported platform: $platform"
      echo "[HINT] Install manually from https://gitlab.com/gitlab-org/cli/-/blob/main/README.md"
      exit 1
      ;;
  esac

  # Verify installation
  if command -v glab &>/dev/null; then
    glab --version
    echo "[OK] Installation verified"
    echo ""
    echo "[HINT] Authenticate with: glab auth login --hostname gitlab.com"
    echo "[HINT] See references/install-and-setup.md for complete setup steps"
  else
    echo "[ERROR] Installation verification failed"
    exit 1
  fi
}

main "$@"
