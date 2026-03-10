# CMake Command Cookbook

## Configure

```bash
# Basic out-of-source configure (always prefer this form)
cmake -S . -B build

# Set build type at configure time
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug

# Pass multiple cache variables
cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTS=ON \
  -DCMAKE_INSTALL_PREFIX=/usr/local

# Choose a generator explicitly
cmake -S . -B build -G "Ninja"
cmake -S . -B build -G "Unix Makefiles"
cmake -S . -B build -G "Visual Studio 17 2022"

# List all available generators
cmake --help
```

## Build

```bash
# Build all targets
cmake --build build

# Build a specific target
cmake --build build --target myapp
cmake --build build --target mylib

# Parallel build (override generator default)
cmake --build build --parallel 8
cmake --build build -j8

# Clean then build
cmake --build build --clean-first

# Verbose output (shows compiler invocations)
cmake --build build --verbose
```

## Install

```bash
# Install to the configured prefix
cmake --install build

# Override install prefix at install time
cmake --install build --prefix /opt/myapp

# Dry run — preview what would be installed
cmake --install build --prefix /tmp/staging
```

## Test (ctest)

```bash
# Run all tests
ctest --test-dir build

# Verbose test output
ctest --test-dir build --verbose

# Run tests matching a regex
ctest --test-dir build -R "unit_"

# Run in parallel
ctest --test-dir build -j4

# Show output on failure
ctest --test-dir build --output-on-failure
```

## Cache Inspection

```bash
# List all non-advanced cache variables
cmake -L build

# List all including advanced variables
cmake -LA build

# Print cache variable with help text
cmake -LH build
```

## Presets

```bash
# List available presets
cmake --list-presets

# Configure with a named preset
cmake --preset debug
cmake --preset release

# Build with a preset
cmake --build --preset release
```
