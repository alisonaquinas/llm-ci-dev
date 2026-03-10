# Deployment Providers

Travis CI includes 30+ built-in deployment providers covering cloud platforms, artifact registries, and custom endpoints.

---

## Popular Providers

### Heroku

Deploy Node.js, Ruby, Python, and other apps to Heroku hosting.

```yaml
deploy:
  provider: heroku
  api_key:
    secure: <encrypted-token>
  app: my-app-production
  on:
    branch: main
```

**Key options:**

- `app` — Target Heroku app name
- `api_key` — Heroku authorization token
- `region` — Optional region (us, eu)

---

### AWS S3

Upload build artifacts to Amazon S3 buckets.

```yaml
deploy:
  provider: s3
  access_key_id:
    secure: <encrypted-key>
  secret_access_key:
    secure: <encrypted-secret>
  bucket: my-artifact-bucket
  region: us-east-1
  skip_cleanup: true
  on:
    branch: main
```

**Key options:**

- `bucket` — S3 bucket name
- `region` — AWS region
- `local_dir` — Directory to upload (default: current dir)
- `upload_dir` — Target path in bucket
- `acl` — Access control (public-read, private, etc.)

---

### AWS Elastic Beanstalk

Deploy containerized and traditional applications to Elastic Beanstalk.

```yaml
deploy:
  provider: elasticbeanstalk
  access_key_id:
    secure: <encrypted-key>
  secret_access_key:
    secure: <encrypted-secret>
  region: us-east-1
  app: my-app
  env: my-app-production
  bucket_name: elasticbeanstalk-artifacts
  skip_cleanup: true
  on:
    branch: main
```

**Key options:**

- `app` — Elastic Beanstalk application name
- `env` — Environment name
- `bucket_name` — S3 bucket for deployment artifacts
- `region` — AWS region

---

### npm

Publish packages to the npm registry.

```yaml
deploy:
  provider: npm
  email: user@example.com
  api_key:
    secure: <encrypted-token>
  skip_cleanup: true
  on:
    tags: true
    repo: owner/repo
    condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$
```

**Key options:**

- `email` — npm account email
- `api_key` — npm authentication token
- `skip_cleanup` — Preserve node_modules and dist for publishing

---

### PyPI

Publish Python packages to PyPI or custom PyPI servers.

```yaml
deploy:
  provider: pypi
  user: __token__
  password:
    secure: <encrypted-token>
  distributions: sdist bdist_wheel
  skip_existing: true
  on:
    tags: true
    condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$
```

**Key options:**

- `user` — PyPI username (use `__token__` for token auth)
- `password` — PyPI password or token
- `distributions` — Build formats (sdist, bdist_wheel)
- `skip_existing` — Skip if version exists
- `server` — Custom PyPI server URL

---

### Docker Hub

Push Docker images to Docker Hub or private registries.

```yaml
deploy:
  provider: script
  script: |
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker build -t $DOCKER_USERNAME/my-app:$TRAVIS_COMMIT .
    docker push $DOCKER_USERNAME/my-app:$TRAVIS_COMMIT
    if [[ ! -z "$TRAVIS_TAG" ]]; then
      docker tag $DOCKER_USERNAME/my-app:$TRAVIS_COMMIT $DOCKER_USERNAME/my-app:$TRAVIS_TAG
      docker push $DOCKER_USERNAME/my-app:$TRAVIS_TAG
    fi
  skip_cleanup: true
  on:
    branch: main
```

**Secure variables:**

- `DOCKER_USERNAME` — Docker Hub username
- `DOCKER_PASSWORD` — Docker Hub token or password

---

### Heroku Container Registry

Push Docker images directly to Heroku's container registry.

```yaml
deploy:
  provider: script
  script: |
    echo $HEROKU_API_KEY | docker login -u _ --password-stdin registry.heroku.com
    docker build -t registry.heroku.com/$HEROKU_APP/web .
    docker push registry.heroku.com/$HEROKU_APP/web
    heroku container:release web --app=$HEROKU_APP
  skip_cleanup: true
  on:
    branch: main
```

**Secure variables:**

- `HEROKU_API_KEY` — Heroku authentication token
- `HEROKU_APP` — Heroku app name

---

### Google Cloud Storage

Upload artifacts to Google Cloud Storage buckets.

```yaml
deploy:
  provider: gcs
  access_key_id:
    secure: <encrypted-key>
  secret_access_key:
    secure: <encrypted-secret>
  bucket: my-gcs-bucket
  skip_cleanup: true
  on:
    branch: main
```

**Key options:**

- `bucket` — GCS bucket name
- `local_dir` — Directory to upload
- `acl` — Access control (public-read, private, etc.)

---

### GitHub Releases

Upload build artifacts to GitHub Releases.

```yaml
deploy:
  provider: releases
  api_key:
    secure: <encrypted-token>
  file:
    - build/app.tar.gz
    - build/app.zip
  skip_cleanup: true
  overwrite: true
  on:
    tags: true
    repo: owner/repo
```

**Key options:**

- `api_key` — GitHub personal access token
- `file` — Files or patterns to attach
- `overwrite` — Replace existing release files
- `draft` — Create as draft (default: false)
- `prerelease` — Mark as pre-release (default: false)

---

### Custom Script Provider

Execute custom deployment scripts for any target.

```yaml
deploy:
  provider: script
  script: ./deploy.sh
  skip_cleanup: true
  on:
    branch: production
```

**Common patterns:**

SSH deploy:

```bash
#!/bin/bash
eval "$(ssh-agent -s)"
chmod 600 deploy_key
ssh-add deploy_key
ssh-keyscan -H $DEPLOY_HOST >> ~/.ssh/known_hosts
rsync -av --delete build/ user@$DEPLOY_HOST:/var/www/app/
```

FTP deploy:

```bash
#!/bin/bash
curl -T build/* ftp://user:$FTP_PASSWORD@ftp.example.com/
```

API deploy:

```bash
#!/bin/bash
curl -X POST https://api.example.com/deploy \
  -H "Authorization: Bearer $API_TOKEN" \
  -d "{\"version\": \"$TRAVIS_COMMIT\"}"
```

---

## Provider Configuration Matrix

| Provider | Auth Type | Primary Use | Key Setting |
| --- | --- | --- | --- |
| Heroku | API Key | PaaS hosting | `api_key` |
| AWS S3 | Access Keys | File storage | `bucket` |
| Elastic Beanstalk | Access Keys | Container/app hosting | `app`, `env` |
| npm | Token | Package registry | `api_key` |
| PyPI | Token/Password | Python packages | `password` |
| Docker Hub | Token | Container images | Script-based |
| Heroku Container Registry | API Key | Container hosting | Script-based |
| Google Cloud Storage | Service account | Cloud storage | `bucket` |
| GitHub Releases | API Token | Release assets | `api_key` |
| Custom Script | Environment vars | Any target | `script` |

---

## Tips

- **skip_cleanup:** Set to `true` when provider needs build artifacts (npm, PyPI, Docker)
- **Multiple providers:** Use array syntax to deploy to multiple targets in sequence
- **Error handling:** Use `|| true` in custom scripts to continue on failure, or let failures block deployment
- **Artifact paths:** Relative paths are resolved from repo root
- **Environment variables:** Reference with `$VAR_NAME` or use `secure:` for encrypted values
