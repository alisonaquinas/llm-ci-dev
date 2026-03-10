# CMake Install & Setup

## Prerequisites

- macOS, Linux, or Windows
- A C/C++ compiler (gcc/clang/MSVC) for building projects
- CMake 3.15+ recommended for most modern projects

## Install by Platform

### macOS (Homebrew)

```bash
brew install cmake

cmake --version
```

### macOS (official installer)

Download the `.dmg` from <https://cmake.org/download/> and install the app bundle. Add to PATH:

```bash
export PATH="/Applications/CMake.app/Contents/bin:$PATH"
```

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install cmake

cmake --version
```

For a newer version than the distro ships:

```bash
# Install via pip (cross-platform, any OS with Python)
pip install cmake
cmake --version
```

### Fedora / RHEL

```bash
sudo dnf install cmake
```

### Windows (winget)

```powershell
winget install Kitware.CMake
```

### Windows (Chocolatey)

```powershell
choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System'
```

### Cross-platform (pip)

```bash
pip install cmake
# Installs the cmake binary into the active Python environment's bin/
cmake --version
```

## Post-Install Verification

```bash
cmake --version
# Expected: cmake version 3.x.x

# Confirm ctest and cpack are also available
ctest --version
cpack --version
```

## Graphical Configuration (cmake-gui)

`cmake-gui` provides a point-and-click interface for setting cache variables:

```bash
# Launch the GUI (opens a window)
cmake-gui
```

Useful for exploring available options in a project for the first time. Equivalent to running `cmake -S . -B build` then editing the cache interactively.

## ccmake (curses UI)

```bash
# Terminal-based interactive cache editor
ccmake -S . -B build
```

Navigate variables with arrow keys, press `c` to configure, `g` to generate.
