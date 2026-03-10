# Credential Management

Securely encrypt and manage API keys, tokens, and credentials in `.travis.yml` using Travis CI's encryption system.

---

## Travis Encrypt for Secure Variables

Encrypt single environment variables or API keys directly in `.travis.yml`.

### Basic Encryption

```bash
# Install travis CLI
gem install travis

# Encrypt an API key (interactive login)
travis encrypt YOUR_API_KEY --add deploy.api_key
```

This prompts for GitHub credentials and adds an encrypted entry to `.travis.yml`:

```yaml
deploy:
  api_key:
    secure: <long-encrypted-string>
```

### Manual Encryption

```bash
# Encrypt value without adding to .travis.yml
travis encrypt HEROKU_API_KEY=abc123xyz

# Copy the output and paste into .travis.yml
deploy:
  api_key:
    secure: <output>
```

### Environment Variables

```bash
# Encrypt environment variable
travis encrypt MY_SECRET_VAR=secret_value --add env.global

# Result in .travis.yml
env:
  global:
    - secure: <encrypted-string>
```

---

## Travis Encrypt-File for Encrypted Files

Encrypt sensitive files (SSH keys, certificates, credentials) for inclusion in the repository.

### Encrypt a Deployment Key

```bash
# Encrypt deploy_key.pem (creates deploy_key.pem.enc)
travis encrypt-file deploy_key.pem

# Output shows decryption command:
# openssl aes-256-cbc -K $encrypted_xxx_key -iv $encrypted_xxx_iv \
#   -in deploy_key.pem.enc -out deploy_key.pem -d
```

### Add Decryption to .travis.yml

```yaml
before_install:
  - openssl aes-256-cbc -K $encrypted_abc123_key -iv $encrypted_abc123_iv \
    -in deploy_key.pem.enc -out deploy_key.pem -d
  - chmod 600 deploy_key.pem
  - eval "$(ssh-agent -s)"
  - ssh-add deploy_key.pem

script:
  - # Your tests

deploy:
  provider: script
  script: ./deploy.sh
```

### Workflow

1. Create a deployment key: `ssh-keygen -f deploy_key -N ""`
2. Encrypt it: `travis encrypt-file deploy_key`
3. Add `deploy_key.enc` to version control
4. Delete the plaintext `deploy_key` from your machine
5. Travis decrypts on each build and uses it for deployment

---

## Secure Variable Visibility

### In Pull Requests

Encrypted variables are **hidden in pull request builds** (for security). To test encrypted variables locally in PRs:

```yaml
env:
  global:
    - secure: <encrypted-var>

script:
  - echo "This will not print the secret in PRs"
```

### Visible Only to Maintainers

Set variables only in Travis CI web UI (not in .travis.yml) to limit exposure:

1. Go to <https://travis-ci.com/owner/repo/settings>
2. Add "Environment Variables" via the UI
3. These do NOT appear in PR logs

### Override in Web UI

Variables set in web UI override those in `.travis.yml` (useful for secrets).

---

## Travis Setup Shortcuts

The travis CLI includes shortcuts to configure popular providers.

### Heroku Setup

```bash
travis setup heroku
# Prompts for:
# - Heroku email
# - Heroku API key
# - Heroku app name
# Automatically adds encrypted credentials to .travis.yml
```

### npm Setup

```bash
travis setup npm
# Prompts for:
# - npm username
# - npm password/token
# - Automatically encrypts and configures deploy block
```

### Other Providers

```bash
travis setup aws
travis setup gcs
travis setup releases
```

---

## Best Practices

### 1. Use Tokens Over Passwords

```yaml
# Good: Use GitHub personal access token
deploy:
  provider: releases
  api_key:
    secure: <token>

# Avoid: Never use plaintext passwords
# deploy:
#   api_key: my-password  # NEVER DO THIS
```

### 2. Encrypt File Contents for Sensitive Data

```bash
# Encrypt entire config file with secrets
travis encrypt-file config.prod.json
```

```yaml
before_install:
  - openssl aes-256-cbc -K $encrypted_key -iv $encrypted_iv \
    -in config.prod.json.enc -out config.prod.json -d
```

### 3. Rotate Keys Regularly

- Change provider API keys periodically
- Regenerate SSH deployment keys
- Update encrypted variables with new secrets

### 4. Limit Scope of Credentials

```bash
# Good: Create repo-specific API token with minimal permissions
# Avoid: Using personal account credentials with full access
```

### 5. Never Commit Plaintext Secrets

```bash
# Bad: Check in deploy_key
# git add deploy_key

# Good: Only check in encrypted file
git add deploy_key.pem.enc
rm deploy_key.pem  # Delete plaintext from working directory
```

### 6. Use Environment Variable Whitelist

Explicitly define required variables in `.travis.yml`:

```yaml
env:
  global:
    - secure: <encrypted-API-KEY>
    - secure: <encrypted-DEPLOY-TOKEN>

script:
  - echo "All required secrets are encrypted"
```

---

## Managing ~/.travis/config.yml

Store permanent Travis CLI configuration and authorization tokens.

### Create Config

```bash
# After running 'travis login', creates ~/.travis/config.yml
travis login
# Stores GitHub token securely
```

### Config File Location

```text
~/.travis/config.yml
```

Contents (do not edit manually):

```yaml
endpoints:
  https://api.travis-ci.com: ...
```

---

## Web UI Variables

Add sensitive credentials via Travis web interface (not in `.travis.yml`).

### Steps

1. Navigate to <https://travis-ci.com/owner/repo/settings>
2. Scroll to "Environment Variables"
3. Add variable name and value
4. Check "Display value in build log" only for non-sensitive vars

### Usage in Builds

```yaml
script:
  - echo "Using WEB_UI_VAR: $WEB_UI_VAR"
```

---

## Complete Credential Example

```yaml
# Encrypted variable
env:
  global:
    - secure: <encrypted-docker-password>

# Encrypted file
before_install:
  - openssl aes-256-cbc -K $encrypted_key -iv $encrypted_iv \
    -in .env.prod.enc -out .env.prod -d
  - chmod 600 .env.prod
  - source .env.prod

# Multiple deployment targets with encrypted keys
deploy:
  - provider: npm
    email: user@example.com
    api_key:
      secure: <encrypted-npm-token>
    on:
      tags: true

  - provider: heroku
    api_key:
      secure: <encrypted-heroku-key>
    app: my-app
    on:
      branch: main

  - provider: script
    script: ./deploy-to-custom.sh
    skip_cleanup: true
    on:
      branch: main
```

The script can access all decrypted environment variables:

```bash
#!/bin/bash
# deploy-to-custom.sh
source .env.prod
curl -X POST https://api.example.com/deploy \
  -H "Authorization: Bearer $DEPLOY_API_KEY" \
  -d "{\"version\": \"$TRAVIS_COMMIT\"}"
```

---

## Tips

- **Regenerate keys:** After accidentally committing a secret, revoke and regenerate the credential
- **Local testing:** Use plaintext env vars locally, never commit them
- **Encrypted files:** Keep .enc files in git; ignore plaintext originals in .gitignore
- **Audit logs:** Check Travis UI for recent deployments and encrypted variable usage
- **Cross-org repos:** Credentials encrypted for one repo cannot be used in another (security feature)
