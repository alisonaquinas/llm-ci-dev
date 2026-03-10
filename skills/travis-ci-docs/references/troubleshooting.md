# Travis CI Docs Troubleshooting

## Finding Error-Specific Documentation

When encountering a Travis CI error, follow these patterns:

### Build Configuration Errors

Common error types and how to find docs:

1. **YAML syntax errors** — Check `https://docs.travis-ci.com/user/customizing-the-build/` for .travis.yml syntax
2. **Installation phase failures** — See `https://docs.travis-ci.com/user/customizing-the-build/#the-install-step` for install directives
3. **Language runtime issues** — Visit the language-specific guide at `https://docs.travis-ci.com/user/languages/language-<name>/`
4. **Test execution failures** — Check language-specific test framework configuration
5. **Deployment failures** — Review `https://docs.travis-ci.com/user/deployment/` for deployment configuration and credentials

### Environment & Variable Issues

1. **Undefined variables** — Check `https://docs.travis-ci.com/user/environment-variables/` for environment setup
2. **Encrypted variable errors** — See `https://docs.travis-ci.com/user/encryption-keys/` for Travis CI CLI encryption tool
3. **Credential not found** — Verify `https://docs.travis-ci.com/user/deployment/#security` for deployment credential setup

### Build & Cache Issues

1. **Cache corruption** — See `https://docs.travis-ci.com/user/caching/#clearing-the-build-cache` to clear cache
2. **Matrix build failures** — Check `https://docs.travis-ci.com/user/customizing-the-build/#build-matrix` for matrix configuration
3. **Job timeout** — Review build timeout settings at `https://docs.travis-ci.com/user/customizing-the-build/#build-timeouts`

### Search Strategy

If the specific error URL is unknown:

1. Start with the appropriate section: `/user/customizing-the-build/`, `/user/languages/`, `/user/deployment/`
2. Use WebFetch on the docs page and search for keywords from the error
3. Check the Travis CI community forums or GitHub Discussions
4. Review your language-specific build guide for common configuration patterns

## Migration Guidance

### From Travis CI to GitHub Actions

Since Travis CI for open-source projects is less commonly used for new projects:

1. GitHub Actions is now the standard for GitHub projects
2. For migration guidance, consult GitHub Actions documentation at `https://docs.github.com/en/actions`
3. Use the `github-docs` skill to look up GitHub Actions equivalents
4. Many tools provide Travis CI → GitHub Actions conversion guidance online

## Community Resources

| Resource | URL | Best For |
| --- | --- | --- |
| Travis CI Status | `https://www.traviscistatus.com/` | Service incidents and status |
| GitHub Discussions | `https://github.com/travis-ci/discussions` | Questions and support (if using GitHub integration) |
| Travis CI Email Support | `support@travis-ci.com` | Account and billing issues |
| travisci/beta GitHub | `https://github.com/travis-ci/beta` | Feature announcements and beta testing |

## Platform Distinction

### .org vs .com

- **travis-ci.org** — Deprecated open-source platform (closed 2020)
- **travis-ci.com** — Current platform for all projects (open-source and private)
- All documentation at `docs.travis-ci.com` applies to `.com`

### Documentation Coverage

All Travis CI documentation assumes the current `.com` platform. Features or URLs mentioned are for the active service.

## Navigation Tips

### Using the Docs Site Effectively

1. **User Guide**: Navigate through `/user/` for sequential learning
2. **Language Guides**: Use `/user/languages/<name>/` for language-specific setup
3. **Deployment Providers**: Use `/user/deployment/providers/` to find your deployment target
4. **Quick Reference**: This quick-reference guide for most common keys
5. **API Reference**: Use `/api/v3/` for programmatic access

### Finding Language-Specific Information

**For language setup**:

- Go to `https://docs.travis-ci.com/user/languages/<language>/`
- Each language guide has default build commands and version management
- Examples: `language-python/`, `language-node-js/`, `language-ruby/`, `language-java/`

**For testing framework integration**:

- Check the language-specific guide for your test framework
- Common examples: pytest (Python), Jest (Node.js), RSpec (Ruby), JUnit (Java)

**For deployment provider**:

- Base: `https://docs.travis-ci.com/user/deployment/providers/`
- Search for your deployment target (Heroku, AWS S3, npm, GitHub Releases, etc.)
- Each provider has specific credential and configuration requirements
