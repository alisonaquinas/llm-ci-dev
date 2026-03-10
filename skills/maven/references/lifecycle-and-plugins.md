# Maven Lifecycle and Plugins

## Three Built-in Lifecycles

### 1. default (main build lifecycle)

Key phases in order:

| Phase | Description |
| --- | --- |
| `validate` | Validate project structure and pom.xml |
| `initialize` | Initialize build state |
| `generate-sources` | Generate source code |
| `compile` | Compile main sources |
| `test-compile` | Compile test sources |
| `test` | Run unit tests |
| `package` | Bundle compiled code into JAR/WAR |
| `pre-integration-test` | Set up environment for integration tests |
| `integration-test` | Execute integration tests |
| `post-integration-test` | Tear down integration test environment |
| `verify` | Verify package is valid |
| `install` | Install to local repository |
| `deploy` | Copy to remote repository |

### 2. clean lifecycle

| Phase | Description |
| --- | --- |
| `pre-clean` | Executes before clean |
| `clean` | Removes `target/` |
| `post-clean` | Executes after clean |

### 3. site lifecycle

| Phase | Description |
| --- | --- |
| `pre-site` | Executes before site generation |
| `site` | Generates project documentation |
| `post-site` | Executes after site generation |
| `site-deploy` | Deploys site to a web server |

## Common Plugins

### maven-compiler-plugin

Compiles Java sources. Set the `release` parameter to target a specific Java version.

```xml
<plugin>
  <artifactId>maven-compiler-plugin</artifactId>
  <version>3.12.1</version>
  <configuration>
    <release>17</release>
  </configuration>
</plugin>
```

### maven-surefire-plugin

Runs unit tests during the `test` phase.

```xml
<plugin>
  <artifactId>maven-surefire-plugin</artifactId>
  <version>3.2.5</version>
  <configuration>
    <includes>
      <include>**/*Test.java</include>
    </includes>
  </configuration>
</plugin>
```

### maven-failsafe-plugin

Runs integration tests during `integration-test` / `verify`. Bound explicitly because it does not bind automatically.

```xml
<plugin>
  <artifactId>maven-failsafe-plugin</artifactId>
  <version>3.2.5</version>
  <executions>
    <execution>
      <goals>
        <goal>integration-test</goal>
        <goal>verify</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

### maven-shade-plugin

Creates an uber-JAR (fat JAR) containing all dependencies.

```xml
<plugin>
  <artifactId>maven-shade-plugin</artifactId>
  <version>3.5.1</version>
  <executions>
    <execution>
      <phase>package</phase>
      <goals><goal>shade</goal></goals>
      <configuration>
        <transformers>
          <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
            <mainClass>com.example.Main</mainClass>
          </transformer>
        </transformers>
      </configuration>
    </execution>
  </executions>
</plugin>
```

### maven-resources-plugin

Copies and filters resources from `src/main/resources` to `target/classes`.

## Repositories

- **Maven Central** (`https://repo.maven.apache.org/maven2`) — default public repository
- **Custom/private** — declare under `<repositories>` in pom.xml; credentials in `~/.m2/settings.xml`
- **Local cache** — `~/.m2/repository`; cleared with `mvn dependency:purge-local-repository`
