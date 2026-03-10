# Jenkins Pipeline Full Reference

Complete breakdown of Jenkins Pipeline (Declarative and Scripted) with keywords and steps.

## Declarative Pipeline Structure

| Keyword/Block | Documentation URL |
| --- | --- |
| Pipeline top-level block | `https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline` |
| `agent` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#agent` |
| `stages` block | `https://www.jenkins.io/doc/book/pipeline/syntax/#stages` |
| `stage` block | `https://www.jenkins.io/doc/book/pipeline/syntax/#stage` |
| `steps` block | `https://www.jenkins.io/doc/book/pipeline/syntax/#steps` |
| `post` block | `https://www.jenkins.io/doc/book/pipeline/syntax/#post` |
| `environment` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#environment` |
| `parameters` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#parameters` |
| `tools` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#tools` |
| `when` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#when` |
| `options` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#options` |
| `input` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#input` |
| `triggers` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#triggers` |

## Advanced Pipeline Concepts

| Concept | Documentation URL |
| --- | --- |
| Scripted Pipeline | `https://www.jenkins.io/doc/book/pipeline/scripted-pipeline/` |
| Shared Libraries | `https://www.jenkins.io/doc/book/pipeline/shared-libraries/` |
| Shared Library structure | `https://www.jenkins.io/doc/book/pipeline/shared-libraries/#directory-structure` |
| Shared Library `vars/` | `https://www.jenkins.io/doc/book/pipeline/shared-libraries/#global-shared-libraries` |
| Pipeline metadata plugins | `https://www.jenkins.io/doc/book/pipeline/extending/` |
| Custom pipeline steps | `https://www.jenkins.io/doc/book/pipeline/extending/#extending-with-shared-libraries` |
| Parallel execution in pipelines | `https://www.jenkins.io/doc/book/pipeline/syntax/#parallel` |
| Sequential stages | `https://www.jenkins.io/doc/book/pipeline/syntax/#sequential-stages` |
| Multibranch Pipelines | `https://www.jenkins.io/doc/book/pipeline/multibranch/` |
| Declarative pipeline linter | `https://www.jenkins.io/doc/book/pipeline/syntax/#validating-declarative-pipelines` |

## Built-in Pipeline Steps

### SCM & Repository Steps

| Step | URL |
| --- | --- |
| `checkout` | `https://www.jenkins.io/doc/pipeline/steps/workflow-scm-steps/#checkout` |
| `git` | `https://www.jenkins.io/doc/pipeline/steps/workflow-scm-steps/#git` |
| `svn` (Subversion) | `https://www.jenkins.io/doc/pipeline/steps/subversion/#svn` |

### File Operations

| Step | URL |
| --- | --- |
| `dir` (change directory) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#dir` |
| `deleteDir` (delete directory) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#deletedir` |
| `fileExists` (check file existence) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#fileexists` |
| `readFile` (read file contents) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#readfile` |
| `writeFile` (write file) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#writefile` |
| `unstash` / `stash` | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash` |
| `archiveArtifacts` | `https://www.jenkins.io/doc/pipeline/steps/core/#archiveartifacts` |

### Execution Control

| Step | URL |
| --- | --- |
| `sh` / `bat` (run shell/batch commands) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#sh` |
| `echo` (print output) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#echo` |
| `error` (fail with message) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#error` |
| `timeout` | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#timeout` |
| `retry` | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#retry` |
| `sleep` | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#sleep` |
| `waitUntil` | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#waituntil` |
| `input` | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#input` |

### Reporting & Notifications

| Step | URL |
| --- | --- |
| `junit` (JUnit test results) | `https://www.jenkins.io/doc/pipeline/steps/junit/#junit` |
| `mail` (send email) | `https://www.jenkins.io/doc/pipeline/steps/mailer/#mail` |
| `publishHTML` (publish HTML reports) | `https://www.jenkins.io/doc/pipeline/steps/htmlpublisher/#publishhtml` |
| `currentBuild` (access build properties) | `https://www.jenkins.io/doc/pipeline/steps/core/#currentbuild` |

### Job Triggers

| Concept | URL |
| --- | --- |
| `build` (trigger another job) | `https://www.jenkins.io/doc/pipeline/steps/pipeline-build-step/#build` |
| Webhook triggers | `https://www.jenkins.io/doc/book/pipeline/syntax/#triggers` |
| Polling SCM | `https://www.jenkins.io/doc/book/pipeline/syntax/#triggers` |
| Cron schedules | `https://www.jenkins.io/doc/book/pipeline/syntax/#cron-syntax` |

## Pipeline Environment & Variables

| Topic | Documentation URL |
| --- | --- |
| Environment variables in Pipeline | `https://www.jenkins.io/doc/book/pipeline/syntax/#environment` |
| Jenkins built-in variables | `https://www.jenkins.io/doc/book/using-jenkins/using-environment-variables/` |
| Credentials binding in Pipeline | `https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials` |
| Parameters in Pipeline | `https://www.jenkins.io/doc/book/pipeline/syntax/#parameters` |
| Tools in Pipeline (Maven, Java, etc.) | `https://www.jenkins.io/doc/book/pipeline/syntax/#tools` |

## Testing & Quality

| Topic | URL |
| --- | --- |
| Pipeline testing with JenkinsPipelineUnit | `https://www.jenkins.io/doc/book/pipeline/pipeline-testing/` |
| JUnit test result integration | `https://www.jenkins.io/doc/pipeline/steps/junit/#junit` |
| Code coverage integration | `https://plugins.jenkins.io/cobertura/` |
| SonarQube integration | `https://plugins.jenkins.io/sonarqube/` |

## Blue Ocean & UI

| Topic | URL |
| --- | --- |
| Blue Ocean overview | `https://www.jenkins.io/doc/book/blueocean/` |
| Blue Ocean for Pipeline | `https://www.jenkins.io/doc/book/blueocean/#blue-ocean-for-declarative-pipeline` |
| Blue Ocean visual editor | `https://www.jenkins.io/doc/book/blueocean/#blue-ocean-visual-editor` |
