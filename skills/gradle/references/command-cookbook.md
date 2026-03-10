# Gradle Command Cookbook

All commands use `./gradlew` (the wrapper). Replace with `gradlew.bat` on Windows.

## Core Lifecycle Tasks

```bash
./gradlew build         # Compile, test, and assemble (most common)
./gradlew test          # Run tests only
./gradlew clean         # Delete build/ directory
./gradlew assemble      # Produce artifacts without running tests
./gradlew check         # Run all verification tasks (tests, lint, etc.)
./gradlew run           # Run the application (requires application plugin)
```

## Discovery

```bash
./gradlew tasks                    # List all available tasks with descriptions
./gradlew tasks --all              # Include tasks without a group
./gradlew dependencies             # Full dependency report for all configurations
./gradlew dependencies --configuration runtimeClasspath  # Specific configuration
./gradlew properties               # List all project properties
```

## Dry Run and Debugging

```bash
./gradlew build -m                 # Dry run: list tasks that would execute
./gradlew build --dry-run          # Same as -m
./gradlew build --info             # Info-level logging
./gradlew build --debug            # Debug-level logging (very verbose)
./gradlew build --scan             # Publish a build scan for analysis
```

## Daemon Control

```bash
./gradlew --daemon                 # Start or reuse the Gradle daemon (default)
./gradlew --no-daemon              # Run without daemon (recommended for CI)
./gradlew --stop                   # Stop all running Gradle daemons
```

## Performance Flags

```bash
./gradlew build --parallel         # Build subprojects in parallel
./gradlew build --configuration-cache  # Cache task graph (faster re-runs)
./gradlew build --build-cache      # Reuse task outputs from previous builds
```

## Task Filtering

```bash
# Exclude a specific task
./gradlew build -x test

# Run tests matching a pattern
./gradlew test --tests "com.example.*IntegrationTest"
./gradlew test --tests "*UserServiceTest.shouldReturnUser"

# Re-run tasks even if outputs are up-to-date
./gradlew test --rerun-tasks
```

## Multi-Project Builds

```bash
# Run a task in a specific subproject
./gradlew :api:build

# Run a task in all subprojects
./gradlew build   # runs from root, cascades to all subprojects

# List subprojects
./gradlew projects
```

## Common CI Pattern

```bash
./gradlew --no-daemon clean build
```

- `--no-daemon` prevents daemon state accumulation across CI jobs
- `clean build` ensures a reproducible build from scratch

## Wrapper Management

```bash
# Update the wrapper to a new Gradle version
./gradlew wrapper --gradle-version 8.8

# Verify wrapper integrity
./gradlew wrapper --validate-distribution-url
```
