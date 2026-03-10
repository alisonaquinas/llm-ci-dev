# Travis CI Docs Site Navigation

## Structure Overview

docs.travis-ci.com is organized into user guides, language-specific guides, and API reference.

### Top-Level Sections

| Section | Base URL | Contents |
| --- | --- | --- |
| **User Guide** | `https://docs.travis-ci.com/user/` | Build configuration, environments, deployment |
| **Language Guides** | `https://docs.travis-ci.com/user/languages/` | Language-specific setup and examples |
| **API v3** | `https://docs.travis-ci.com/api/v3/` | REST API reference |
| **Build Configuration** | `https://docs.travis-ci.com/user/customizing-the-build/` | .travis.yml syntax and options |

### Main User Guide Sections

The User Guide (`/user/`) is organized into major topics:

| Topic | Base URL | Contents |
| --- | --- | --- |
| **Customizing the Build** | `https://docs.travis-ci.com/user/customizing-the-build/` | .travis.yml format and all configuration keys |
| **Build Stages** | `https://docs.travis-ci.com/user/build-stages/` | Organizing builds into stages |
| **Caching** | `https://docs.travis-ci.com/user/caching/` | Dependency and directory caching strategies |
| **Environment Variables** | `https://docs.travis-ci.com/user/environment-variables/` | Setting and using environment variables |
| **Deployment** | `https://docs.travis-ci.com/user/deployment/` | Deployment providers and configuration |
| **Languages** | `https://docs.travis-ci.com/user/languages/` | Language-specific build configuration |
| **Notifications** | `https://docs.travis-ci.com/user/notifications/` | Email, Slack, and other notifications |
| **Web Hooks** | `https://docs.travis-ci.com/user/webhooks/` | Webhook configuration and management |

### Language-Specific Guides

Travis CI provides language guides at:

```text
https://docs.travis-ci.com/user/language-<language>/
```

Common languages:

- `language-python/` — Python projects
- `language-node-js/` — Node.js projects
- `language-ruby/` — Ruby projects
- `language-go/` — Go projects
- `language-java/` — Java projects
- `language-csharp/` — C# / .NET projects
- `language-docker/` — Docker images
- `language-php/` — PHP projects

### Platform Variants

#### Note: .org vs .com distinction

- `travis-ci.org` — Deprecated; historical open-source platform (moved to `.com`)
- `travis-ci.com` — Current platform for all projects (open-source and private)

All documentation at `docs.travis-ci.com` applies to the current `.com` platform.

### Common Navigation Paths

**Build Configuration (`/user/customizing-the-build/`)**:

- `.travis.yml` format overview
- `language` directive
- `os` and `dist` selection
- `install`, `script`, `before_script`, `after_script` phases
- `matrix` expansion and `jobs.include` / `jobs.exclude`
- Conditional builds with `if`
- `notifications` section

**Build Stages (`/user/build-stages/`)**:

- Stage organization and naming
- `jobs.include` with stages
- Conditional stages
- Stage deployment matrix

**Deployment (`/user/deployment/`)**:

- Deployment providers (S3, Heroku, npm, GitHub Pages, GitHub Releases, etc.)
- Conditional deployment with `on` clause
- Security and encrypted credentials
- Custom deployment scripts

**Caching (`/user/caching/`)**:

- Package manager caching (pip, npm, bundler, maven)
- Directory caching patterns
- Cache key strategies
- Clearing cache

**Environment Variables (`/user/environment-variables/`)**:

- Defining `env` variables
- Secure variables (encrypted)
- Global vs per-build variables
- Built-in Travis CI variables

**Languages** (`/user/languages/`):

- `before_install` phases (tool installation)
- Default `install` and `script` commands
- Test framework integration
- Version selection

### URL Structure Notes

- Trailing slashes are inconsistent; try both with and without if a page doesn't load
- The API reference is at `/api/v3/` (not v1 or v2)
- Language guides use kebab-case: `language-node-js` (not `language-nodejs`)
