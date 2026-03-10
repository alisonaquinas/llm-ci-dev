#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Platform {
  if ($IsWindows) { return 'windows' }
  if ($IsMacOS) { return 'macos' }
  if ($IsLinux) { return 'linux' }
  return 'unknown'
}

function Main {
  $platform = Get-Platform

  # Check if glab is already installed
  if (Get-Command glab -ErrorAction SilentlyContinue) {
    $version = & glab --version
    Write-Host "[OK] $version already installed"
    Write-Host "[HINT] See 'references/install-and-setup.md' for post-install configuration"
    return
  }

  switch ($platform) {
    'windows' {
      Write-Host "[INFO] Installing GitLab CLI on Windows via winget..."
      if (Get-Command winget -ErrorAction SilentlyContinue) {
        & winget install --id=glab-cli.glab
        Write-Host "[OK] glab installed successfully"
      } else {
        Write-Host "[ERROR] winget not found"
        Write-Host "[HINT] Try scoop: scoop install glab"
        Write-Host "[HINT] Or download from https://gitlab.com/gitlab-org/cli/-/releases"
        exit 1
      }
    }

    'macos' {
      Write-Host "[INFO] Installing GitLab CLI on macOS via Homebrew..."
      if (Get-Command brew -ErrorAction SilentlyContinue) {
        & brew install glab
        Write-Host "[OK] glab installed successfully"
      } else {
        Write-Host "[ERROR] Homebrew not found. Install from https://brew.sh"
        exit 1
      }
    }

    'linux' {
      Write-Host "[INFO] Installing GitLab CLI on Linux..."
      if (Test-Path '/etc/os-release') {
        $osInfo = Get-Content /etc/os-release | ConvertFrom-StringData
        $distro = $osInfo.ID

        switch ($distro) {
          { $_ -in 'debian', 'ubuntu' } {
            Invoke-WebRequest -Uri "https://repo.gitlab.com/api/v4/projects/gitlab-org%2Fglabcli/packages/debian/distributions" | ConvertFrom-Json | ForEach-Object {
              $disturl = $_.repository_html_url
              & sudo bash -c "curl -s $disturl | bash"
            }
            & sudo apt update
            & sudo apt install -y glab
          }
          { $_ -in 'fedora', 'rhel', 'centos' } {
            & sudo dnf install -y glab
          }
          'arch' {
            & sudo pacman -S --noconfirm glab
          }
          default {
            Write-Host "[WARN] Unknown distro: $distro"
            exit 1
          }
        }
        Write-Host "[OK] glab installed successfully"
      }
    }

    default {
      Write-Host "[ERROR] Unsupported platform: $platform"
      exit 1
    }
  }

  # Verify installation
  if (Get-Command glab -ErrorAction SilentlyContinue) {
    & glab --version
    Write-Host "[OK] Installation verified"
    Write-Host ""
    Write-Host "[HINT] Authenticate with: glab auth login --hostname gitlab.com"
    Write-Host "[HINT] See 'references/install-and-setup.md' for complete setup steps"
  } else {
    Write-Host "[ERROR] Installation verification failed"
    exit 1
  }
}

Main
