# Shared Libraries — Reusable Pipeline Code and Custom Steps

## Overview

Jenkins Shared Libraries allow you to factor out common pipeline logic into reusable modules. Libraries provide custom steps, utilities, and domain-specific helpers that multiple pipelines can depend on. This reference covers library structure, the `@Library` annotation, the `call()` method pattern, loading strategies, and testing approaches.

---

## Shared Library Structure

### Directory Layout

A Shared Library follows this structure:

```bash
my-shared-library/
├── vars/
│   ├── myStep.groovy          # Custom step (callable via @Field functions)
│   ├── notifySlack.groovy
│   └── deployApp.groovy
├── src/
│   └── com/example/jenkins/
│       ├── PipelineUtils.groovy
│       └── DeploymentHelper.groovy
└── resources/
    ├── templates/
    │   └── email-template.html
    └── scripts/
        └── deploy.sh
```

### vars/ — Custom Steps

Files in `vars/` become custom steps available in any pipeline using the library:

```groovy
// vars/myStep.groovy
def call(String name) {
  echo "Hello, ${name}!"
}
```

**Usage in pipeline:**

```groovy
@Library('my-shared-library') _

pipeline {
  agent any

  stages {
    stage('Test') {
      steps {
        myStep('Alice')  // Outputs: Hello, Alice!
      }
    }
  }
}
```

### src/ — Groovy Classes

Classes in `src/` can be imported and used by steps or other classes:

```groovy
// src/com/example/jenkins/Utils.groovy
package com.example.jenkins

class Utils {
  static String getVersion(script) {
    return script.sh(
      script: 'cat version.txt',
      returnStdout: true
    ).trim()
  }

  static boolean isMainBranch(script) {
    return script.env.BRANCH_NAME == 'main'
  }
}
```

**Usage:**

```groovy
// vars/buildApp.groovy
import com.example.jenkins.Utils

def call(script) {
  def version = Utils.getVersion(script)
  def isMain = Utils.isMainBranch(script)

  if (isMain) {
    script.echo "Building version ${version} on main branch"
    script.sh "mvn clean package"
  }
}
```

### resources/ — Templates and Scripts

Store static files (templates, shell scripts, config) in `resources/`:

```groovy
// vars/deployWithTemplate.groovy
def call(String env) {
  def templateContent = libraryResource('templates/deploy-config.json')
  writeFile file: '/tmp/config.json', text: templateContent
  sh "deploy.sh --config /tmp/config.json --env ${env}"
}
```

---

## @Library Annotation

### Implicit Loading (Recommended)

Use `@Library` at the pipeline level to load a library:

```groovy
@Library('my-shared-library') _

pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        myStep('param')
      }
    }
  }
}
```

The underscore `_` indicates implicit loading—all vars/ functions are available without import.

### Explicit Loading

Load specific classes:

```groovy
@Library('my-shared-library') import com.example.jenkins.Utils

pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        script {
          def version = Utils.getVersion(this)
          echo "Version: ${version}"
        }
      }
    }
  }
}
```

### Multiple Libraries

Load multiple libraries:

```groovy
@Library('library-a') _
@Library('library-b') _

pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        stepFromA()
        stepFromB()
      }
    }
  }
}
```

### Library Configuration in Jenkins

Register libraries in Jenkins UI:

1. Manage Jenkins → Configure System → Global Pipeline Libraries
2. Add new library with name and Git repository URL
3. Optionally set to "Load implicitly" to auto-load in all pipelines
4. Specify default branch (usually `main` or `master`)

---

## Var Pattern — Global Variables with call()

### Basic Pattern

Define a global variable with a `call()` method:

```groovy
// vars/myStep.groovy
def call(String name, Integer age = 0) {
  echo "Name: ${name}, Age: ${age}"
}
```

**Usage:**

```groovy
myStep('Alice')
myStep('Bob', 30)
```

### Pattern with Map Parameters

Accept a map for keyword arguments:

```groovy
// vars/buildApp.groovy
def call(Map config) {
  def version = config.version ?: '1.0.0'
  def env = config.environment ?: 'dev'
  def skipTests = config.skipTests ?: false

  echo "Building version ${version} for ${env}"

  if (skipTests) {
    sh 'mvn clean package -DskipTests'
  } else {
    sh 'mvn clean package'
  }
}
```

**Usage:**

```groovy
buildApp(version: '2.0.0', environment: 'prod')
buildApp(version: '1.5.0', skipTests: true)
```

### Pattern with Nested Configuration

```groovy
// vars/deployPipeline.groovy
def call(Map config) {
  def app = config.app ?: [:]
  def deploy = config.deploy ?: [:]

  echo "Deploying ${app.name} v${app.version} to ${deploy.environment}"

  stage('Build') {
    sh "${app.buildCommand}"
  }

  stage('Deploy') {
    sh "${deploy.script} --env ${deploy.environment}"
  }
}
```

**Usage:**

```groovy
deployPipeline(
  app: [
    name: 'myapp',
    version: '1.0',
    buildCommand: 'mvn clean package'
  ],
  deploy: [
    environment: 'production',
    script: './deploy.sh'
  ]
)
```

---

## Pipeline Syntax in Shared Libraries

### Using `this` for Pipeline Context

When calling pipeline steps from library code, use `this` to reference the pipeline context:

```groovy
// vars/myStep.groovy
def call(String message) {
  this.echo message
  this.sh 'echo Done'
}
```

Or rely on implicit binding:

```groovy
// vars/myStep.groovy
def call(String message) {
  echo message
  sh 'echo Done'
}
```

### Calling Library Functions from Steps

```groovy
// vars/complexStep.groovy
def call(Map config) {
  checkout()
  build(config)
  test()
  deploy(config)
}

def checkout() {
  echo 'Checking out...'
  sh 'git fetch'
}

def build(Map config) {
  echo "Building for ${config.env}"
  sh 'mvn clean package'
}

def test() {
  echo 'Running tests...'
  sh 'mvn test'
}

def deploy(Map config) {
  echo "Deploying to ${config.env}"
  sh "./deploy.sh ${config.env}"
}
```

**Usage:**

```groovy
complexStep(env: 'production')
```

---

## Library Loading Strategies

### Implicit Loading (from Global Configuration)

Jenkins automatically loads libraries configured as "Load implicitly" in Manage Jenkins:

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        myStep()  // Step from implicitly loaded library
      }
    }
  }
}
```

### Explicit Loading with Version

Specify a library version (tag, branch, or commit):

```groovy
@Library('my-shared-library@main') _

pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        myStep()
      }
    }
  }
}
```

### Versioned Tags

```groovy
@Library('my-shared-library@v1.2.0') _

pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        myStep()
      }
    }
  }
}
```

### Dynamic Loading (Advanced)

Load a library programmatically:

```groovy
@Library('my-shared-library') _

pipeline {
  agent any

  stages {
    stage('Dynamic Load') {
      steps {
        script {
          if (env.BRANCH_NAME == 'main') {
            // Already loaded, but can conditionally use features
            myStep()
          }
        }
      }
    }
  }
}
```

---

## Reusing Steps

### Step Library Example

```groovy
// vars/notifySlack.groovy
def call(String channel, String message, String color = 'good') {
  sh '''
    curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK \
      -H 'Content-Type: application/json' \
      -d '{
        "channel": "#${channel}",
        "text": "${message}",
        "color": "${color}"
      }'
  '''
}
```

**Usage in multiple pipelines:**

```groovy
@Library('my-shared-library') _

pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }
  }

  post {
    success {
      notifySlack('ci', 'Build succeeded!', 'good')
    }
    failure {
      notifySlack('ci', 'Build failed!', 'danger')
    }
  }
}
```

### Shared Deployment Step

```groovy
// vars/deployToKubernetes.groovy
def call(Map config) {
  def image = config.image ?: error('image is required')
  def namespace = config.namespace ?: 'default'
  def deployment = config.deployment ?: error('deployment is required')

  sh '''
    kubectl set image deployment/${deployment} \
      app=${image} \
      -n ${namespace} \
      --record
  '''

  sh "kubectl rollout status deployment/${deployment} -n ${namespace}"
}
```

**Usage:**

```groovy
@Library('my-shared-library') _

pipeline {
  agent any

  environment {
    REGISTRY = 'docker.io'
    IMAGE_NAME = "${REGISTRY}/myapp:${BUILD_NUMBER}"
  }

  stages {
    stage('Build & Push Image') {
      steps {
        sh 'docker build -t ${IMAGE_NAME} .'
        sh 'docker push ${IMAGE_NAME}'
      }
    }

    stage('Deploy to Dev') {
      steps {
        deployToKubernetes(
          image: "${IMAGE_NAME}",
          namespace: 'dev',
          deployment: 'myapp'
        )
      }
    }

    stage('Deploy to Prod') {
      when { branch 'main' }
      steps {
        input 'Deploy to production?'
        deployToKubernetes(
          image: "${IMAGE_NAME}",
          namespace: 'production',
          deployment: 'myapp'
        )
      }
    }
  }
}
```

---

## Testing Shared Libraries

### Unit Testing with JenkinsPipelineUnit

Use the Jenkins Pipeline Unit testing framework:

```groovy
// test/com/example/jenkins/UtilsTest.groovy
import static org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import com.lesfurets.jenkins.unit.BasePipelineTest

class UtilsTest extends BasePipelineTest {
  @Before
  void setUp() {
    super.setUp()
    binding.setVariable('fileExists', { String path -> true })
  }

  @Test
  void testGetVersion() {
    def script = binding
    script.sh = { Map args -> 'v1.2.3' }

    def version = Utils.getVersion(script)
    assertEquals('v1.2.3', version)
  }
}
```

### Integration Testing

Test vars in a pipeline context:

```groovy
// test/vars/myStepTest.groovy
import static org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import com.lesfurets.jenkins.unit.BasePipelineTest

class myStepTest extends BasePipelineTest {
  @Before
  void setUp() {
    super.setUp()
    binding.setVariable('myStep', { String name -> println("Hello, ${name}!") })
  }

  @Test
  void testMyStep() {
    myStep('Alice')
    printCallStack()
    assertTrue(callStack.any { it.contains('Hello') })
  }
}
```

---

## Complete Example: Shared Library

### Library Repository Structure

```bash
jenkins-shared-library/
├── vars/
│   ├── buildMaven.groovy
│   ├── notifySlack.groovy
│   └── deployToKubernetes.groovy
├── src/
│   └── com/example/jenkins/
│       ├── Utils.groovy
│       └── KubernetesHelper.groovy
├── resources/
│   └── templates/
│       └── deployment.yaml
└── test/
    └── com/example/jenkins/
        └── UtilsTest.groovy
```

### Library Implementation

```groovy
// vars/buildMaven.groovy
def call(Map config) {
  def goals = config.goals ?: 'clean package'
  def profiles = config.profiles ?: ''
  def javaVersion = config.javaVersion ?: '11'

  echo "Building with Maven (JDK ${javaVersion})"

  stage('Maven Build') {
    sh "mvn ${goals} ${profiles ? '-P ' + profiles : ''}"
  }

  stage('Run Tests') {
    sh 'mvn test'
  }

  stage('Generate Reports') {
    sh 'mvn jacoco:report'
  }
}
```

```groovy
// vars/notifySlack.groovy
def call(String channel, String message, String status = 'info') {
  def colors = [
    success: '#36a64f',
    failure: '#ff0000',
    info: '#0099ff'
  ]

  sh '''
    curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK \
      -H 'Content-Type: application/json' \
      -d "{
        \"channel\": \"${channel}\",
        \"text\": \"${message}\",
        \"color\": \"${colors[status]}\"
      }"
  '''
}
```

### Pipeline Using Library

```groovy
@Library('jenkins-shared-library') _

pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        buildMaven(
          goals: 'clean package',
          profiles: 'production',
          javaVersion: '11'
        )
      }
    }

    stage('Deploy') {
      when { branch 'main' }
      steps {
        deployToKubernetes(
          image: "docker.io/myapp:${BUILD_NUMBER}",
          namespace: 'production',
          deployment: 'myapp'
        )
      }
    }
  }

  post {
    success {
      notifySlack('#ci', 'Build succeeded!', 'success')
    }
    failure {
      notifySlack('#ci', 'Build failed!', 'failure')
    }
  }
}
```

---
