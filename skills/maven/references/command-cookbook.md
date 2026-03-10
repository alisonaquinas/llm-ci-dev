# Maven Command Cookbook

## Default Lifecycle Phases

Run any phase to execute all preceding phases first.

```bash
mvn validate        # Validate pom.xml and project structure
mvn compile         # Compile src/main/java
mvn test            # Compile and run unit tests (Surefire)
mvn package         # Produce JAR/WAR in target/
mvn verify          # Run integration tests (Failsafe) after package
mvn install         # Copy artifact to ~/.m2/repository
mvn deploy          # Upload artifact to remote repository
```

## Clean Lifecycle

```bash
mvn clean           # Delete target/ directory
mvn clean install   # Clean then run full default lifecycle to install
mvn clean package   # Clean then compile, test, and package
```

## Site Lifecycle

```bash
mvn site            # Generate project site (reports, Javadoc)
```

## Dependency Commands

```bash
mvn dependency:tree                     # Display full dependency tree
mvn dependency:resolve                  # Resolve and list all dependencies
mvn dependency:analyze                  # Find unused/undeclared dependencies
```

## Versions Plugin

```bash
mvn versions:display-dependency-updates   # Show available dependency upgrades
mvn versions:display-plugin-updates       # Show available plugin upgrades
mvn versions:set -DnewVersion=2.0.0       # Set project version
```

## Useful Flags

| Flag | Purpose |
| --- | --- |
| `-DskipTests` | Skip test execution (tests still compiled) |
| `-Dmaven.test.skip=true` | Skip test compilation and execution entirely |
| `-B` / `--batch-mode` | Non-interactive output, suitable for CI |
| `-T 4` | Build with 4 threads (parallel module builds) |
| `-T 1C` | One thread per CPU core |
| `-pl module-a,module-b` | Build only the listed modules |
| `-am` | Also build modules that listed modules depend on |
| `-amd` | Also build modules that depend on listed modules |
| `-o` | Offline mode — use local cache only |
| `-U` | Force update of snapshot dependencies |
| `-e` | Print full stack traces on errors |
| `-q` | Quiet output (errors and warnings only) |
| `-X` | Debug output |

## Multi-Module Examples

```bash
# Build only the api module and its dependencies
mvn -pl api -am clean install

# Build everything except the slow integration-tests module
mvn install -pl '!integration-tests'
```

## Common CI Pattern

```bash
mvn -B clean verify --no-transfer-progress
```

- `-B` suppresses interactive prompts
- `verify` includes integration tests
- `--no-transfer-progress` reduces log noise from artifact downloads
