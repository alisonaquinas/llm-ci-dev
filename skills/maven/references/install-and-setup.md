# Maven Install & Setup

## Prerequisites

- JDK 8 or later (JAVA_HOME must be set)
- 64-bit OS (macOS, Linux, or Windows)

## Verify JAVA_HOME

```bash
echo $JAVA_HOME
# Expected: /usr/lib/jvm/java-17-openjdk or similar
java -version
```

## Install by Platform

### macOS (Homebrew)

```bash
brew install maven

# Verify
mvn --version
```

### Linux (apt — Ubuntu/Debian)

```bash
sudo apt update && sudo apt install maven

# Verify
mvn --version
```

### SDKMAN (cross-platform, recommended)

```bash
# Install SDKMAN first if not present
curl -s "https://get.sdkman.io" | bash

# Install latest Maven
sdk install maven

# Install a specific version
sdk install maven 3.9.6

# Switch versions
sdk use maven 3.9.6
```

### Manual Binary

```bash
# Check https://maven.apache.org/download.cgi for latest version
MVN_VERSION=3.9.6
curl -Lo maven.tar.gz "https://downloads.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz"
tar -xzf maven.tar.gz -C /opt
export PATH="/opt/apache-maven-${MVN_VERSION}/bin:$PATH"
```

## Maven Wrapper (mvnw)

The Maven wrapper allows projects to declare their required Maven version without a global install.

```bash
# Generate wrapper in an existing project (requires Maven installed once)
mvn wrapper:wrapper

# Use the wrapper
./mvnw --version
./mvnw clean install

# Windows
mvnw.cmd clean install
```

The wrapper downloads the declared Maven version on first use and caches it in `.mvn/wrapper/`.

## settings.xml

Global settings live at `~/.m2/settings.xml`. Common uses: mirror configuration, proxy settings, server credentials.

```xml
<settings>
  <mirrors>
    <mirror>
      <id>central</id>
      <url>https://repo.maven.apache.org/maven2</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
</settings>
```

Never commit credentials in `settings.xml` to version control. Use CI secret injection to write the file at build time.

## Post-Install Verification

```bash
mvn --version
# Expected output: Apache Maven 3.x.x ...
```
