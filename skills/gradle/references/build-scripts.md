# Gradle Build Scripts

## DSL Choices

Gradle supports two DSLs. Both are functionally equivalent; Kotlin DSL offers better IDE autocompletion.

| File | DSL |
| --- | --- |
| `build.gradle` | Groovy |
| `build.gradle.kts` | Kotlin |

## Minimal build.gradle (Groovy)

```groovy
plugins {
    id 'java'
}

group = 'com.example'
version = '1.0.0'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web:3.2.0'
    testImplementation 'org.junit.jupiter:junit-jupiter:5.10.0'
}

test {
    useJUnitPlatform()
}
```

## Minimal build.gradle.kts (Kotlin DSL)

```kotlin
plugins {
    id("java")
}

group = "com.example"
version = "1.0.0"

repositories {
    mavenCentral()
    google()  // required for Android and some Google libraries
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web:3.2.0")
    testImplementation("org.junit.jupiter:junit-jupiter:5.10.0")
}

tasks.test {
    useJUnitPlatform()
}
```

## Dependency Configurations

| Configuration | Scope |
| --- | --- |
| `implementation` | Compile + runtime; not exposed to consumers |
| `api` | Compile + runtime; exposed to consumers (requires `java-library` plugin) |
| `compileOnly` | Compile only; not present at runtime |
| `runtimeOnly` | Runtime only; not on compile classpath |
| `testImplementation` | Test compile + runtime |
| `testRuntimeOnly` | Test runtime only |

## settings.gradle / settings.gradle.kts

Defines the root project name and includes subprojects:

```groovy
// settings.gradle (Groovy)
rootProject.name = 'my-app'
include('core', 'api', 'web')
```

```kotlin
// settings.gradle.kts (Kotlin)
rootProject.name = "my-app"
include("core", "api", "web")
```

## gradle.properties

```properties
# Performance tuning
org.gradle.jvmargs=-Xmx2g
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configuration-cache=true

# Project properties (non-sensitive)
appVersion=1.0.0
```

## Multi-Project Builds

Each subproject has its own `build.gradle` (or `build.gradle.kts`). The root `build.gradle` can apply shared configuration:

```groovy
// root build.gradle
subprojects {
    apply plugin: 'java'

    repositories { mavenCentral() }

    dependencies {
        testImplementation 'org.junit.jupiter:junit-jupiter:5.10.0'
    }
}
```
