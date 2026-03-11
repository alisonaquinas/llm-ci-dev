# Make Install & Setup

## Prerequisites

- macOS, Linux, or Windows (via WSL or native port)
- A terminal with standard Unix tools

## Install by Platform

### macOS (Homebrew)

```bash
# Install GNU Make (macOS ships an older BSD make)
brew install make

# GNU make installs as 'gmake'; add to PATH to use as 'make'
echo 'export PATH="$(brew --prefix make)/libexec/gnubin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
make --version
```

### macOS (Xcode Command Line Tools)

```bash
# Installs Apple's make (BSD-flavored, but sufficient for most projects)
xcode-select --install

make --version
```

### Ubuntu / Debian

```bash
# build-essential includes make, gcc, g++, and libc-dev
sudo apt update
sudo apt install build-essential

make --version
```

### Fedora / RHEL / CentOS

```bash
sudo dnf groupinstall "Development Tools"

make --version
```

### Windows (WSL)

```bash
# Inside a WSL2 Ubuntu shell
sudo apt update && sudo apt install build-essential
```

### Windows (native — chocolatey)

```powershell
choco install make
```

## Post-Install Verification

```bash
make --version
# Expected: GNU Make 4.x

# Check that make finds a Makefile in the current directory
echo -e 'hello:\n\t@echo "Make is working"' > /tmp/Makefile
make -f /tmp/Makefile hello
# Output: Make is working
```

## POSIX Compliance

Add `.POSIX:` as the very first target in a Makefile to opt into strict POSIX behavior:

```makefile
.POSIX:

all:
 $(CC) -o myapp main.c
```

This disables GNU extensions and improves portability to non-GNU make implementations.
