---
name: gradle
description: Build and manage Java and Android projects with Gradle. Use when tasks mention gradle commands, build.gradle, Gradle wrapper, tasks, plugins, or Android builds.
---

# Gradle

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup, Gradle wrapper | `references/install-and-setup.md` | Gradle needs to be installed or the ./gradlew wrapper configured |
| build.gradle structure, dependencies, settings | `references/build-scripts.md` | Work involves editing build scripts or adding dependencies |
| CLI commands, build workflows | `references/command-cookbook.md` | Specific ./gradlew commands or flags are needed |
| Task definition, plugins, publishing | `references/tasks-and-plugins.md` | Questions about custom tasks or plugin configuration arise |

## Quick Start

```bash
# Build project (compile + test + assemble)
./gradlew build

# Run tests only
./gradlew test

# Preview tasks without executing (dry run)
./gradlew build -m

# Clean build outputs
./gradlew clean
```

## Core Command Tracks

- **Build:** `./gradlew build` — compiles, tests, and assembles the project
- **Test:** `./gradlew test` — runs the test suite
- **Clean:** `./gradlew clean` — deletes `build/` directory
- **Assemble:** `./gradlew assemble` — produces all output artifacts without running tests
- **Check:** `./gradlew check` — runs all verification tasks (tests, linting, etc.)
- **Dependencies:** `./gradlew dependencies` — displays the dependency graph
- **Tasks:** `./gradlew tasks` — lists all available tasks with descriptions
- **Dry run:** append `-m` or `--dry-run` to preview task execution order

## Safety Guardrails

- Always use `./gradlew` (the wrapper) rather than a globally installed `gradle` binary — this ensures the correct Gradle version is used.
- Run `./gradlew build -m` (dry run) before unfamiliar or destructive tasks to preview execution order.
- Use `--no-daemon` in CI environments to avoid daemon state leaking between builds.
- Avoid the Gradle daemon inside Docker containers — the daemon may hold file locks or consume unexpected memory.
- Never commit secrets in `gradle.properties`; inject sensitive values via CI environment variables.

```bash
# Troubleshoot a failing build: check dependency conflicts and run with full stacktrace
./gradlew dependencies --configuration runtimeClasspath
./gradlew build --no-daemon --stacktrace 2>&1 | tail -30
```

## Related Skills

- **maven** — alternative JVM build tool using XML (pom.xml)
- **ci-architecture** — integrating Gradle builds into CI/CD pipelines
- **aws** — deploying Gradle-built artifacts to AWS services

## References

- `references/install-and-setup.md`
- `references/build-scripts.md`
- `references/command-cookbook.md`
- `references/tasks-and-plugins.md`
- Official docs: <https://docs.gradle.org>
- Plugin portal: <https://plugins.gradle.org>
- Android build: <https://developer.android.com/build>
