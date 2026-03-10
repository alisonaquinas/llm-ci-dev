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

  # Check if aws-cli is already installed
  if (Get-Command aws -ErrorAction SilentlyContinue) {
    $version = & aws --version
    Write-Host "[OK] $version already installed"
    Write-Host "[HINT] See 'references/install-and-setup.md' for post-install configuration"
    return
  }

  switch ($platform) {
    'windows' {
      Write-Host "[INFO] Installing AWS CLI v2 on Windows via winget..."
      if (Get-Command winget -ErrorAction SilentlyContinue) {
        & winget install Amazon.AWSCLI
        Write-Host "[OK] AWS CLI installed successfully"
      } else {
        Write-Host "[ERROR] winget not found"
        Write-Host "[HINT] Download from https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
        exit 1
      }
    }

    'macos' {
      Write-Host "[INFO] Installing AWS CLI v2 on macOS via Homebrew..."
      if (Get-Command brew -ErrorAction SilentlyContinue) {
        & brew install awscli
        Write-Host "[OK] AWS CLI installed successfully"
      } else {
        Write-Host "[ERROR] Homebrew not found. Install from https://brew.sh"
        exit 1
      }
    }

    'linux' {
      Write-Host "[INFO] Installing AWS CLI v2 on Linux..."
      Write-Host "[INFO] Using official AWS installer..."

      $tmpdir = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
      try {
        Push-Location $tmpdir
        Invoke-WebRequest -Uri "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -OutFile "awscliv2.zip"
        Expand-Archive awscliv2.zip
        & sudo ./aws/install
        Write-Host "[OK] AWS CLI installed successfully"
      } finally {
        Pop-Location
        Remove-Item $tmpdir -Recurse -Force
      }
    }

    default {
      Write-Host "[ERROR] Unsupported platform: $platform"
      exit 1
    }
  }

  # Verify installation
  if (Get-Command aws -ErrorAction SilentlyContinue) {
    & aws --version
    Write-Host "[OK] Installation verified"
    Write-Host ""
    Write-Host "[HINT] Configure with: aws configure"
    Write-Host "[HINT] See 'references/install-and-setup.md' for complete setup steps"
  } else {
    Write-Host "[ERROR] Installation verification failed"
    exit 1
  }
}

Main
