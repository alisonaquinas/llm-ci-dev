# Jenkins Docs Troubleshooting

## Finding Error-Specific Documentation

When encountering a Jenkins error, follow these patterns:

### Pipeline Errors

Common error types and how to find docs:

1. **Jenkinsfile syntax errors** — Check `https://www.jenkins.io/doc/book/pipeline/syntax/` for correct Declarative Pipeline syntax
2. **Step not found errors** — Visit `https://www.jenkins.io/doc/pipeline/steps/` to search for available steps
3. **Shared Library load failures** — See `https://www.jenkins.io/doc/book/pipeline/shared-libraries/` for structure and configuration
4. **Agent connection issues** — Check `https://www.jenkins.io/doc/book/pipeline/syntax/#agent` for agent configuration
5. **Pipeline timeout** — Consult `https://www.jenkins.io/doc/book/pipeline/syntax/#options` for timeout settings

### Build & Execution Errors

1. **Build failures** — Check build logs in Jenkins UI; use the Pipeline Syntax Snippet Generator at `/pipeline-syntax/` to validate step syntax
2. **Credentials not working** — See `https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#handling-credentials` for credentials binding
3. **Artifact archiving issues** — Review `https://www.jenkins.io/doc/pipeline/steps/core/#archiveartifacts` for correct paths and patterns
4. **Plugin compatibility issues** — Visit `https://plugins.jenkins.io/` to check plugin documentation and version compatibility

### Search Strategy

If the specific error URL is unknown:

1. Use the Jenkins UI's **Snippet Generator** at `/pipeline-syntax/` for quick step lookup
2. Search `https://www.jenkins.io/doc/pipeline/steps/` for keyword matching
3. Check the Jenkins community forum at `https://community.jenkins.io/` for crowd-sourced solutions
4. Review Jenkins issue tracker at `https://issues.jenkins.io/` for reported bugs
5. Consult plugin documentation at `https://plugins.jenkins.io/<plugin-name>/`

## Jenkins UI Debugging Tools

### Snippet Generator

The **Snippet Generator** is built into Jenkins at:

```text
https://<jenkins-url>/pipeline-syntax/
```

Use it to:

- Find available steps for installed plugins
- Generate correct step syntax with parameters
- Validate step configuration

### Declarative Pipeline Linter

Validate Jenkinsfile syntax:

```text
https://<jenkins-url>/pipeline-model-converter/validate
```

Or via CLI:

```bash
curl -X POST -d @Jenkinsfile http://<jenkins-url>/pipeline-model-converter/validate
```

## Community Resources

| Resource | URL | Best For |
| --- | --- | --- |
| Jenkins Community | `https://community.jenkins.io/` | Questions and community support |
| Jenkins JIRA | `https://issues.jenkins.io/` | Bug reports and feature requests |
| GitHub Issues (Jenkins org) | `https://github.com/jenkinsci/` | Jenkins and plugin source code |
| Jenkins Mailing Lists | `https://www.jenkins.io/mailing-lists/` | Email discussion groups |
| Weekly Releases | `https://www.jenkins.io/changelog/` | Release notes and changelog |

## Plugin-Specific Documentation

### Finding Plugin Docs

1. Visit `https://plugins.jenkins.io/<plugin-id>/`
2. Look for documentation link or GitHub repository link
3. Some plugins link to their own docs site or wiki pages
4. Check the plugin's GitHub issues for common problems

### Common Plugin Search Patterns

```text
https://plugins.jenkins.io/docker/           — Docker plugin
https://plugins.jenkins.io/git/               — Git plugin
https://plugins.jenkins.io/pipeline-job/      — Pipeline job plugin
https://plugins.jenkins.io/blueocean/         — Blue Ocean plugin
https://plugins.jenkins.io/junit/             — JUnit plugin
https://plugins.jenkins.io/slack/             — Slack notifications
https://plugins.jenkins.io/matrix-auth/       — Matrix-based authorization
```

## Navigation Tips

### Using the Docs Site Effectively

1. **Book chapters**: Navigate through `/doc/book/` for sequential learning
2. **Steps reference**: Use `/doc/pipeline/steps/` for quick lookup
3. **Snippet Generator**: Leverage the Jenkins UI tool for syntax help
4. **Pipeline Syntax validation**: Use the built-in linter at `/pipeline-model-converter/validate`
5. **Search**: Use Ctrl+F on docs pages or Jenkins community search

### Finding Specific Information

**Finding pipeline agents**:

- Start at `https://www.jenkins.io/doc/book/pipeline/syntax/#agent`
- Common agents: `any`, `label`, `docker`, `kubernetes`

**Finding step parameters**:

- Go to Snippet Generator at `/pipeline-syntax/` (built into Jenkins)
- Or search steps reference: `https://www.jenkins.io/doc/pipeline/steps/`

**Finding shared library examples**:

- Base: `https://www.jenkins.io/doc/book/pipeline/shared-libraries/`
- Check the directory structure and global variable documentation sections
