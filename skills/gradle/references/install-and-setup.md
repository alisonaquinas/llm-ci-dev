# Gradle Install & Setup

## Prerequisites

- JDK 8 or later (JAVA_HOME must be set)
- 64-bit OS (macOS, Linux, or Windows)

## Verify JAVA_HOME

```bash
echo $JAVA_HOME
java -version
```

## Install by Platform

### SDKMAN (cross-platform, recommended)

```bash
# Install SDKMAN first if not present
curl -s "https://get.sdkman.io" | bash

# Install latest Gradle
sdk install gradle

# Install a specific version
sdk install gradle 8.7

# Switch versions
sdk use gradle 8.7
```

### macOS (Homebrew)

```bash
brew install gradle

# Verify
gradle --version
```

### Linux (manual binary)

```bash
GRADLE_VERSION=8.7
curl -Lo gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
unzip gradle.zip -d /opt
export PATH="/opt/gradle-${GRADLE_VERSION}/bin:$PATH"
gradle --version
```

## Gradle Wrapper (Recommended)

The Gradle wrapper is the standard way to use Gradle in projects. It downloads and caches the declared version automatically.

```bash
# Generate wrapper in an existing project (requires one-time global Gradle install)
gradle wrapper --gradle-version 8.7

# Files generated:
#   gradlew          (Unix shell script)
#   gradlew.bat      (Windows batch script)
#   gradle/wrapper/gradle-wrapper.properties
#   gradle/wrapper/gradle-wrapper.jar

# Use the wrapper for all subsequent commands
./gradlew --version
./gradlew build

# Windows
gradlew.bat build
```

Always commit wrapper files to version control. This allows any developer or CI system to build without a pre-installed Gradle.

## Initialize a New Project

```bash
# Interactive project scaffolding
gradle init

# Prompts for project type (application, library, etc.) and DSL (Groovy or Kotlin)
```

## Post-Install Verification

```bash
gradle --version
# or, inside a project with the wrapper:
./gradlew --version
# Expected: Gradle 8.x
```

## gradle.properties

Place project-wide configuration in `gradle.properties` at the project root:

```properties
org.gradle.jvmargs=-Xmx2g -XX:+HeapDumpOnOutOfMemoryError
org.gradle.parallel=true
org.gradle.caching=true
```

Secrets (API keys, passwords) belong in `~/.gradle/gradle.properties`, not in the project-level file.
