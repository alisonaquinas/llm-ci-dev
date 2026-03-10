# Jenkins Docs Quick Reference

Most-needed Jenkins documentation pages with direct URLs.

## Pipeline Fundamentals (Top 10)

| Topic | URL |
| --- | --- |
| Declarative Pipeline syntax reference | `https://www.jenkins.io/doc/book/pipeline/syntax/` |
| Declarative vs Scripted Pipeline | `https://www.jenkins.io/doc/book/pipeline/scripted-pipeline/` |
| Shared Libraries overview | `https://www.jenkins.io/doc/book/pipeline/shared-libraries/` |
| Creating Shared Libraries | `https://www.jenkins.io/doc/book/pipeline/shared-libraries/#directory-structure` |
| Pipeline best practices | `https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/` |
| Multibranch Pipelines | `https://www.jenkins.io/doc/book/pipeline/multibranch/` |
| Triggering Pipelines | `https://www.jenkins.io/doc/book/pipeline/#controlling-job-execution` |
| Pipeline as Code with Jenkinsfile | `https://www.jenkins.io/doc/book/pipeline/#declaring-pipelines` |
| Blue Ocean introduction | `https://www.jenkins.io/doc/book/blueocean/` |
| Pipeline Syntax Snippet Generator | `https://www.jenkins.io/doc/book/pipeline/getting-started-with-pipeline/#snippet-generator` |

## Pipeline Keywords Reference (Top 10)

| Keyword | URL |
| --- | --- |
| `agent` block | `https://www.jenkins.io/doc/book/pipeline/syntax/#agent` |
| `stages` and `stage` blocks | `https://www.jenkins.io/doc/book/pipeline/syntax/#stages` |
| `steps` block | `https://www.jenkins.io/doc/book/pipeline/syntax/#steps` |
| `post` block (cleanup, always, success, failure) | `https://www.jenkins.io/doc/book/pipeline/syntax/#post` |
| `environment` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#environment` |
| `parameters` directive | `https://www.jenkins.io/doc/book/pipeline/syntax/#parameters` |
| `tools` directive (maven, java, gradle, etc.) | `https://www.jenkins.io/doc/book/pipeline/syntax/#tools` |
| `when` directive (conditions) | `https://www.jenkins.io/doc/book/pipeline/syntax/#when` |
| `parallel` block | `https://www.jenkins.io/doc/book/pipeline/syntax/#parallel` |
| `options` directive (timestamps, timeout, retry) | `https://www.jenkins.io/doc/book/pipeline/syntax/#options` |

## Common Pipeline Steps (Top 15)

| Step | Documentation |
| --- | --- |
| `sh` / `bat` (shell commands) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#sh` |
| `echo` (print output) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#echo` |
| `checkout` (SCM checkout) | `https://www.jenkins.io/doc/pipeline/steps/workflow-scm-steps/#checkout` |
| `git` (Git operations) | `https://www.jenkins.io/doc/pipeline/steps/workflow-scm-steps/#git` |
| `archiveArtifacts` (store build artifacts) | `https://www.jenkins.io/doc/pipeline/steps/core/#archiveartifacts` |
| `junit` (publish JUnit test results) | `https://www.jenkins.io/doc/pipeline/steps/junit/#junit` |
| `stash` / `unstash` (save/restore files) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#stash` |
| `mail` (send email) | `https://www.jenkins.io/doc/pipeline/steps/mailer/#mail` |
| `build` (trigger another job) | `https://www.jenkins.io/doc/pipeline/steps/pipeline-build-step/#build` |
| `input` (wait for user input) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#input` |
| `sleep` (pause pipeline) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#sleep` |
| `dir` (change directory) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#dir` |
| `timeout` (set step timeout) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#timeout` |
| `retry` (retry on failure) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#retry` |
| `waitUntil` (wait for condition) | `https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/#waituntil` |

## Installation & Setup (Top 5)

| Topic | URL |
| --- | --- |
| How to install Jenkins | `https://www.jenkins.io/doc/book/getting-started/how-to-install-jenkins/` |
| Installing Jenkins on Linux | `https://www.jenkins.io/doc/book/installing-jenkins/linux/` |
| Installing Jenkins on Docker | `https://www.jenkins.io/doc/book/installing-jenkins/docker/` |
| Installing Jenkins on Kubernetes | `https://www.jenkins.io/doc/book/installing-jenkins/kubernetes/` |
| Post-installation setup | `https://www.jenkins.io/doc/book/getting-started/initial-settings/` |

## Security & Administration (Top 5)

| Topic | URL |
| --- | --- |
| Security guide | `https://www.jenkins.io/doc/book/managing/security/` |
| Managing plugins | `https://www.jenkins.io/doc/book/managing/plugins/` |
| Pipeline Unit Testing (JenkinsPipelineUnit) | `https://www.jenkins.io/doc/book/pipeline/pipeline-testing/` |
| Backup and restore | `https://www.jenkins.io/doc/book/managing/backup/` |
| Performance monitoring | `https://www.jenkins.io/doc/book/system-administration/monitoring/` |

## Popular Plugins (Top 5)

| Plugin | URL |
| --- | --- |
| Docker plugin | `https://plugins.jenkins.io/docker-commons/` |
| Git plugin | `https://plugins.jenkins.io/git/` |
| Pipeline job plugin | `https://plugins.jenkins.io/workflow-job/` |
| Blue Ocean plugin | `https://plugins.jenkins.io/blueocean/` |
| Slack notification | `https://plugins.jenkins.io/slack/` |
