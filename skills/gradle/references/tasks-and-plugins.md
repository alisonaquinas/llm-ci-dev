# Gradle Tasks and Plugins

## Defining Custom Tasks

### Register a task (Kotlin DSL)

```kotlin
tasks.register("greet") {
    group = "custom"
    description = "Prints a greeting"
    doLast {
        println("Hello from Gradle!")
    }
}
```

### Register a task (Groovy DSL)

```groovy
tasks.register('greet') {
    group = 'custom'
    description = 'Prints a greeting'
    doLast {
        println 'Hello from Gradle!'
    }
}
```

## Task Dependencies

```kotlin
tasks.register("packageAll") {
    dependsOn("build", "generateDocs")
}

// Make test always run after compile
tasks.named("test") {
    mustRunAfter("compileJava")
}
```

## Custom Task Types

```kotlin
abstract class CopyReports : DefaultTask() {
    @get:InputDirectory abstract val sourceDir: DirectoryProperty
    @get:OutputDirectory abstract val destDir: DirectoryProperty

    @TaskAction
    fun copy() {
        project.copy {
            from(sourceDir)
            into(destDir)
        }
    }
}

tasks.register<CopyReports>("copyReports") {
    sourceDir.set(layout.buildDirectory.dir("reports"))
    destDir.set(layout.projectDirectory.dir("published-reports"))
}
```

## Common Plugins

### java plugin

Adds `compileJava`, `test`, `jar` tasks and standard source sets.

```kotlin
plugins { id("java") }
```

### java-library plugin

Extends `java` with the `api` dependency configuration for libraries consumed by other projects.

```kotlin
plugins { id("java-library") }
```

### application plugin

Adds `run` task and distribution packaging.

```kotlin
plugins { id("application") }

application {
    mainClass.set("com.example.Main")
}
```

### spring-boot plugin

```kotlin
plugins {
    id("org.springframework.boot") version "3.2.0"
    id("io.spring.dependency-management") version "1.1.4"
}
```

Adds `bootJar`, `bootRun`, and `bootBuildImage` tasks.

### maven-publish plugin

Publishes artifacts to Maven repositories.

```kotlin
plugins { id("maven-publish") }

publishing {
    publications {
        create<MavenPublication>("mavenJava") {
            from(components["java"])
        }
    }
    repositories {
        maven {
            url = uri("https://nexus.example.com/repository/maven-releases/")
            credentials {
                username = providers.environmentVariable("NEXUS_USER").get()
                password = providers.environmentVariable("NEXUS_PASS").get()
            }
        }
    }
}
```

Publish with: `./gradlew publish`

## Gradle Wrapper Update

```bash
# Bump the wrapper to a specific version
./gradlew wrapper --gradle-version 8.8

# Commit the updated wrapper files
git add gradle/wrapper/gradle-wrapper.properties gradlew gradlew.bat gradle/wrapper/gradle-wrapper.jar
git commit -m "chore: update Gradle wrapper to 8.8"
```
