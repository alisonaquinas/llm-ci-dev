---
name: maven
description: Build and manage Java projects with Apache Maven. Use when tasks mention mvn commands, pom.xml, dependency management, lifecycle phases, or Maven plugins.
---

# Maven

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup, Maven wrapper | `references/install-and-setup.md` | Maven needs to be installed or the mvnw wrapper configured |
| pom.xml structure, dependencies, plugins | `references/pom-xml.md` | Work involves editing pom.xml, adding dependencies, or configuring plugins |
| CLI commands, build workflows | `references/command-cookbook.md` | Specific mvn commands or flags are needed |
| Lifecycle phases, common plugins | `references/lifecycle-and-plugins.md` | Questions about build lifecycle or plugin configuration arise |

## Quick Start

```bash
# Validate project (check pom.xml)
mvn validate

# Compile source code
mvn compile

# Run tests
mvn test

# Package (creates JAR/WAR)
mvn package

# Install to local repository
mvn install
```

## Core Command Tracks

- **Validate:** `mvn validate` — checks pom.xml is well-formed before any build steps
- **Compile:** `mvn compile` — compiles main source under `src/main/java`
- **Test:** `mvn test` — runs unit tests via Surefire plugin
- **Package:** `mvn package` — produces JAR or WAR artifact in `target/`
- **Verify:** `mvn verify` — runs integration tests via Failsafe plugin after packaging
- **Install:** `mvn install` — copies artifact to local `~/.m2/repository`
- **Deploy:** `mvn deploy` — uploads artifact to remote repository
- **Clean:** `mvn clean` — removes `target/` directory
- **Dependency tree:** `mvn dependency:tree` — displays resolved dependency graph
- **Skip tests:** append `-DskipTests` only when necessary (e.g., quick local packaging)

## Safety Guardrails

- Run `mvn validate` before any deploy operation to catch malformed pom.xml early.
- Use `--batch-mode` (`-B`) in CI pipelines to suppress interactive prompts and produce consistent output.
- Never skip tests in production pipelines; `-DskipTests` is reserved for specific local scenarios.
- Prefer the `mvnw` (Maven wrapper) script when present — it guarantees a consistent Maven version across environments.
- Avoid committing `~/.m2/settings.xml` secrets to version control; use CI secret injection instead.

```bash
# Troubleshoot dependency conflicts: inspect the tree and resolve duplication
mvn dependency:tree -Dincludes=com.fasterxml.jackson.core
mvn dependency:analyze
```

## Related Skills

- **gradle** — alternative JVM build tool using Groovy/Kotlin DSL
- **ci-architecture** — integrating Maven builds into CI/CD pipelines
- **aws** — deploying Maven-built artifacts to AWS services

## References

- `references/install-and-setup.md`
- `references/pom-xml.md`
- `references/command-cookbook.md`
- `references/lifecycle-and-plugins.md`
- Official docs: <https://maven.apache.org/guides/>
- Maven Central: <https://search.maven.org>
- Plugin index: <https://maven.apache.org/plugins/>
