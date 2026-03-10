# Maven pom.xml Reference

## Project Coordinates

Every Maven project is identified by GAV coordinates:

```xml
<groupId>com.example</groupId>
<artifactId>my-app</artifactId>
<version>1.0.0-SNAPSHOT</version>
<packaging>jar</packaging>  <!-- jar (default), war, pom -->
```

## Parent POM

Inherit shared configuration from a parent:

```xml
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>3.2.0</version>
</parent>
```

## Dependencies

```xml
<dependencies>
  <!-- Compile scope (default): available at compile and runtime -->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>

  <!-- Test scope: only available during test compilation and execution -->
  <dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.10.0</version>
    <scope>test</scope>
  </dependency>

  <!-- Provided scope: expected from the runtime container (e.g., servlet-api) -->
  <dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
  </dependency>

  <!-- Runtime scope: not needed at compile time, but required at runtime -->
  <dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>
  </dependency>
</dependencies>
```

## dependencyManagement

Centralise version declarations (often in a parent POM) without forcing the dependency on child modules:

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.16.0</version>
    </dependency>
  </dependencies>
</dependencyManagement>
```

Child modules then declare the dependency without a version tag.

## Properties

```xml
<properties>
  <java.version>17</java.version>
  <maven.compiler.source>${java.version}</maven.compiler.source>
  <maven.compiler.target>${java.version}</maven.compiler.target>
  <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
```

## Build / Plugins

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.12.1</version>
      <configuration>
        <release>17</release>
      </configuration>
    </plugin>
  </plugins>
</build>
```

## pluginManagement

Declare plugin versions in a parent to enforce consistency without binding them to lifecycle phases in child POMs.

## Profiles

Activate different configurations based on environment:

```xml
<profiles>
  <profile>
    <id>production</id>
    <activation>
      <property><name>env</name><value>prod</value></property>
    </activation>
    <properties>
      <log.level>WARN</log.level>
    </properties>
  </profile>
</profiles>
```

Activate with: `mvn package -Pproduction`

## Repositories and distributionManagement

```xml
<repositories>
  <repository>
    <id>my-nexus</id>
    <url>https://nexus.example.com/repository/maven-public/</url>
  </repository>
</repositories>

<distributionManagement>
  <repository>
    <id>releases</id>
    <url>https://nexus.example.com/repository/maven-releases/</url>
  </repository>
  <snapshotRepository>
    <id>snapshots</id>
    <url>https://nexus.example.com/repository/maven-snapshots/</url>
  </snapshotRepository>
</distributionManagement>
```
