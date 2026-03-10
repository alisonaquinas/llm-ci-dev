# pip — Command Cookbook

## Install Packages

```bash
# Install the latest version of a package
pip install requests

# Install a specific version
pip install "requests==2.31.0"

# Install with version constraints
pip install "flask>=3.0,<4"

# Install from a requirements file
pip install -r requirements.txt

# Install with hash verification (supply-chain hardening)
pip install --require-hashes -r requirements.txt

# Install without dependencies (use with care)
pip install --no-deps mypackage
```

## Editable Install

Links the source directory into site-packages so changes are reflected immediately without reinstalling:

```bash
# Install current project in editable mode
pip install -e .

# Editable install with optional extras
pip install -e ".[dev,test]"
```

## Uninstall

```bash
pip uninstall requests
pip uninstall -y requests    # skip confirmation prompt
pip uninstall -r requirements.txt -y
```

## List and Inspect

```bash
# List all installed packages
pip list

# Show packages with newer versions available
pip list --outdated

# Show details for a specific package
pip show requests

# Show the files installed by a package
pip show --files requests
```

## Check for Conflicts

```bash
# Verify all installed packages have compatible dependencies
pip check
```

Exit code is non-zero if conflicts are found; useful in CI.

## Freeze

```bash
# Output all installed packages with pinned versions
pip freeze

# Save to a requirements file
pip freeze > requirements.txt

# Exclude editable installs
pip freeze --exclude-editable > requirements.txt
```

## Download Without Installing

```bash
# Download packages to a local directory (for air-gapped installs)
pip download -r requirements.txt -d ./vendor

# Download for a specific platform
pip download --platform manylinux_2_28_x86_64 \
  --python-version 311 --only-binary :all: \
  -r requirements.txt -d ./vendor
```

## Build a Wheel

```bash
# Build a wheel for the current project
pip wheel .

# Build wheels for a requirements file
pip wheel -r requirements.txt -w ./dist
```

## Hash Utilities

```bash
# Compute the hash of a downloaded file
pip hash ./dist/mypackage-1.0-py3-none-any.whl
```

## Cache Management

```bash
# Show cache info
pip cache info

# List cached files
pip cache list

# Remove all cached files
pip cache purge

# Remove cached files for a specific package
pip cache remove requests
```

## Inspect Environment

```bash
# Show detailed environment and install information (pip 22.2+)
pip inspect
```
