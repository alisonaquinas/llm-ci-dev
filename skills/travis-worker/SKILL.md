---
name: travis-worker
description: >
  Configure Travis CI SaaS build environments and manage travis-worker daemon for Travis CI Enterprise self-hosted deployments.
  Cover SaaS environment selection (OS, distribution, architecture), enterprise worker installation and registration,
  worker pool sizing and configuration, and operational management.
---

# Travis Worker

Configure Travis CI SaaS build environments and manage `travis-worker` daemon for Travis CI Enterprise deployments.
This skill covers environment selection and customization on SaaS, and worker installation, configuration, and operations for TCI-E.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| SaaS Build Environments | `references/saas-build-environments.md` | Selecting OS, distribution, and architecture for jobs on travis-ci.com |
| Enterprise Installation | `references/enterprise-installation.md` | Installing and registering travis-worker daemon for Travis CI Enterprise |
| Enterprise Configuration | `references/enterprise-configuration.md` | Pool sizing, build images, resource limits, and worker groups in TCI-E |
| Operations | `references/operations.md` | Starting, stopping, draining, monitoring, and troubleshooting travis-worker |

---

## Quick Start

### SaaS vs Enterprise: Key Distinction

Travis CI has two deployment modes with different worker management models:

| Mode | SaaS (travis-ci.com) | Enterprise (TCI-E) |
| --- | --- | --- |
| **Hosting** | Managed by Travis CI | Self-hosted in your infrastructure |
| **Worker Management** | Travis CI maintains workers | You operate travis-worker daemon |
| **Configuration Location** | .travis.yml in repository | travis-worker config file + web UI |
| **Build Environment** | Controlled via .travis.yml `os:`, `dist:`, `arch:` | Custom Docker images you build |
| **Scaling** | Automatic | Manual pool sizing + queue monitoring |

### SaaS Build Environment Selection (travis-ci.com)

Specify build environment in `.travis.yml`:

```yaml
os: linux               # linux, osx, windows
dist: jammy            # Ubuntu distribution: focal, jammy, noble
arch: amd64            # amd64, arm64, ppc64le, s390x
language: node_js
node_js:
  - 18
```

### Enterprise Worker Quick Start

Install and register `travis-worker` for Travis CI Enterprise:

```bash
# Install from deb repository
curl -L https://deb.travis-ci.com/key.pub | sudo apt-key add -
echo "deb https://deb.travis-ci.com travis main" | sudo tee /etc/apt/sources.list.d/travis.list
sudo apt-get update
sudo apt-get install travis-worker

# Configure environment variables
sudo mkdir -p /etc/travis-worker
sudo tee /etc/default/travis-worker > /dev/null <<EOF
export TRAVIS_WORKER_AMQP_URI="amqp://user:pass@rabbitmq.example.com"
export TRAVIS_WORKER_POOL_SIZE=4
export TRAVIS_WORKER_DOCKER_IMAGE="travis-ci/worker"
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable travis-worker
sudo systemctl start travis-worker
sudo systemctl status travis-worker
```

---

## Cross-References

Use alongside these skills for deeper context:

- **travis-ci** — Write and maintain .travis.yml pipelines for Travis CI
- **travis-ci-docs** — Deep syntax reference for Travis CI configuration
- **ci-architecture** — Design patterns for multi-worker deployments and environment selection

---

## Related References

- Load **SaaS Build Environments** to configure OS, distribution, and architecture for travis-ci.com
- Load **Enterprise Installation** to install and register travis-worker daemon
- Load **Enterprise Configuration** for worker pool sizing, custom images, and resource limits
- Load **Operations** for monitoring, logging, draining, and troubleshooting workers
