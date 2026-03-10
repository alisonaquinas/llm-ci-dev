# Jenkins Docs Site Navigation

## Structure Overview

jenkins.io/doc is organized into chapters within the "Book" (main guide). Plugin documentation is hosted separately on plugins.jenkins.io.

### Top-Level Sections

| Section | Base URL | Contents |
| --- | --- | --- |
| **Book** | `https://www.jenkins.io/doc/book/` | Official Jenkins guide with chapters on getting started, pipeline, managing, system administration |
| **Pipeline** | `https://www.jenkins.io/doc/book/pipeline/` | Declarative Pipeline, Scripted Pipeline, Shared Libraries, best practices |
| **Steps Reference** | `https://www.jenkins.io/doc/pipeline/steps/` | Complete reference of all available pipeline steps (sh, echo, junit, checkout, etc.) |
| **Security** | `https://www.jenkins.io/security/` | Security advisories and fixes |
| **Plugins** | `https://plugins.jenkins.io/` | Individual plugin documentation (separate site) |
| **Community** | `https://www.jenkins.io/doc/book/community/` | Contributing to Jenkins, code of conduct |
| **Resources** | `https://www.jenkins.io/doc/` | All available documentation resources |

### Main Book Chapters

The Jenkins Book (`/doc/book/`) is organized into chapters:

| Chapter | Base URL | Contents |
| --- | --- | --- |
| **Getting Started** | `https://www.jenkins.io/doc/book/getting-started/` | Installation, setup, initial configuration |
| **Installing Jenkins** | `https://www.jenkins.io/doc/book/installing-jenkins/` | Installation guides for different platforms (Linux, Windows, macOS, Docker, Kubernetes) |
| **Using Jenkins** | `https://www.jenkins.io/doc/book/using-jenkins/` | Core concepts, jobs, projects, builds |
| **Pipeline** | `https://www.jenkins.io/doc/book/pipeline/` | Declarative and Scripted Pipeline, Shared Libraries, blue ocean |
| **Managing Jenkins** | `https://www.jenkins.io/doc/book/managing/` | Backup, restore, plugins, security, user management |
| **System Administration** | `https://www.jenkins.io/doc/book/system-administration/` | Configuration, clustering, performance tuning |

### Common Navigation Paths

**Pipeline Section (`/book/pipeline/`)**:

- `/book/pipeline/syntax/` — Declarative Pipeline syntax reference
- `/book/pipeline/scripted-pipeline/` — Scripted Pipeline (Groovy-based)
- `/book/pipeline/shared-libraries/` — Creating and using Shared Libraries
- `/book/pipeline/extending/` — Extending Pipeline with custom steps
- `/book/pipeline/pipeline-best-practices/` — Best practices and patterns
- `/book/pipeline/multibranch/` — Multibranch Pipelines
- `/book/pipeline/getting-started-with-pipeline/` — Introductory guide

**Steps Reference (`/pipeline/steps/`)**:

- All available steps are listed and searchable
- Built-in steps: `sh`, `bat`, `echo`, `checkout`, `git`, `unstash`, `stash`, `junit`, `archiveArtifacts`
- Plugin-provided steps: steps provided by installed plugins
- Each step has documentation with parameters and examples

**Getting Started (`/book/getting-started/`)**:

- `/book/getting-started/how-to-install-jenkins/` — Installation instructions
- `/book/getting-started/create-a-job/` — Creating first job
- `/book/getting-started/run-jenkins-in-docker/` — Docker installation

**Security (`/security/`)**:

- `/security/advisories/` — Security advisories for Jenkins and plugins
- `/doc/book/managing/security/` — Security configuration guide
- `/doc/book/managing/script-approval/` — Script approval for Groovy scripts

### URL Structure Notes

- Trailing slashes matter consistently
- Plugin documentation URLs follow pattern: `https://plugins.jenkins.io/<plugin-id>/` (replace spaces/hyphens as needed)
- Steps reference is searchable and filterable by plugin
- Each plugin has its own documentation hosted at plugins.jenkins.io

### Finding Plugin Documentation

Plugins are hosted at `https://plugins.jenkins.io/`:

1. Search by plugin name (e.g., `docker`, `git`, `junit`, `pipeline`)
2. Each plugin page lists documentation links and usage information
3. Some plugins link to external documentation or GitHub repos
4. The Snippet Generator (built into Jenkins UI at `/pipeline-syntax/`) provides quick access to step parameters for installed plugins
