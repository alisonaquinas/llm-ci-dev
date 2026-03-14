# Changelog

All notable changes to the llm-ci-dev collection will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2026-03-14

### Changed

- standardized the repo on a Make-first build and validation workflow: `make lint`, `make test`, `make build`, `make verify`, and `make all`
- added repo-owned Python packaging helpers and stdlib-only tests so ZIP verification and skill checks behave consistently across Windows-backed WSL and GitHub Actions
- renamed the primary GitHub Actions quality workflow to `CI` in `.github/workflows/ci.yml` and aligned release automation to run `make test`, build `built/*.zip`, attach artifacts, and skip marketplace dispatch cleanly when the token is missing
- kept `linting/` and `validation/` shell entrypoints as compatibility wrappers around the new Python baseline for one release cycle
- aligned the public repo and plugin identity on `llm-ci-dev` so plugin metadata, install examples, and human-facing docs now match the actual repo name and ZIP archive root
- fully self-contained the release workflow by provisioning `jq` explicitly and updated the release guide to match the automated `make test` + `make all` release path and optional marketplace dispatch behavior

## [1.1.0] - 2026-03-13

### Fixed

- `skills/1password-cli`: corrected the Windows winget package ID from `AgileBits.1PasswordCLI` to `AgileBits.1Password.CLI` in the install reference.
- Added an explicit `text` language tag to the failure example in `docs/release-workflow.md` so repository markdownlint checks pass cleanly.
- `.claude-plugin/plugin.json`: bumped the published plugin version to `1.1.0`

## [1.0.1] - 2026-03-11

### Added

- **AGENTS.md**: Release Process section documenting steps to sync `plugin.json` version with git tag and update `CHANGELOG.md` before every release

## [1.0.0] - 2026-03-11

### Added

#### Kubernetes Tooling Skills (7 new skills)

- **kubectl** skill: Manage Kubernetes resources, contexts, and workloads with kubectl
  - 4 reference docs: install-and-setup.md, command-cookbook.md, resource-management.md, troubleshooting.md
  - Content: install by platform (curl, Homebrew, apt/yum, asdf), kubeconfig and KUBECONFIG env var, multi-context management; get/describe/apply/delete/edit, logs with --previous/-f/--since, exec -it, port-forward, rollout status/history/undo, scale, patch, cp, top, --dry-run=client -o yaml, -o jsonpath, kubectl diff; declarative vs imperative, labels and selectors, namespaces, kubectl explain, resource types cheat-sheet, kustomize integration; CrashLoopBackOff/OOMKilled/ImagePullBackOff diagnosis, kubectl describe pod events, kubectl debug ephemeral containers, node pressure, events sorting, resource quota inspection, taints and tolerations

- **helm** skill: Package and deploy Kubernetes applications with Helm charts and releases
  - 4 reference docs: install-and-setup.md, command-cookbook.md, chart-authoring.md, release-management.md
  - Content: install by platform (binary, Homebrew, apt, asdf), HELM_DATA_HOME/CACHE_HOME/CONFIG_HOME, repo add/update/list/remove, OCI registry auth; helm install/upgrade --install, --dry-run --debug, list/status/uninstall/rollback/history, get values/manifest/notes, --set/-f, helm template, show values, search repo/hub, pull, OCI commands; Chart.yaml required fields, templates/ structure, values.yaml hierarchy, _helpers.tpl, built-in objects (.Release/.Values/.Chart/.Capabilities), NOTES.txt, helm create/lint/package; release lifecycle, --atomic, --wait, upgrade strategies, helm diff plugin, --namespace/--create-namespace, secrets plugin, multi-env values pattern

- **kustomize** skill: Customize Kubernetes manifests with overlay and base patterns using Kustomize
  - 4 reference docs: install-and-setup.md, command-cookbook.md, kustomization-structure.md, overlays-and-bases.md
  - Content: standalone binary install, kubectl built-in apply -k, version mismatch note, KUSTOMIZE_PLUGIN_HOME; kustomize build, pipe to kubectl apply, kubectl diff -k, kustomize edit set image/namespace/nameprefix; kustomization.yaml anatomy, resources/images/configMapGenerator/secretGenerator/namePrefix/patches/replacements; base/overlay layout, environment overlays, strategic merge patches, JSON patches, components:, multi-base overlays, GitOps integration

- **skaffold** skill: Build, push, and deploy to Kubernetes iteratively with Skaffold
  - 4 reference docs: install-and-setup.md, command-cookbook.md, skaffold-yaml.md, profiles-and-ci.md
  - Content: install by platform, SKAFFOLD_DEFAULT_REPO, ~/.skaffold/ config; skaffold dev/run/build/deploy/delete/debug/render, --profile, --tail, diagnose, init; skaffold.yaml top-level structure, build.artifacts[], Docker/Buildpacks/Jib/Kaniko builders, kubectl/helm/kustomize deployers, sync.infer; profiles for dev/staging/prod, activation methods, artifact caching, CI integration patterns, --status-check, multi-module repos

- **tilt** skill: Develop Kubernetes services locally with Tilt and Tiltfiles
  - 4 reference docs: install-and-setup.md, command-cookbook.md, tiltfile-patterns.md, extensions-and-teams.md
  - Content: install by platform, prerequisites (kind/k3d/minikube), TILT_HOST/TILT_PORT, tilt doctor; tilt up/down/ci/trigger/get/describe/logs, TUI keyboard shortcuts; Starlark Tiltfile, docker_build with live_update, k8s_yaml, k8s_resource, local_resource, helm_resource, include/load, allow_k8s_contexts; Tilt extensions, mono-repo patterns, tilt args, Tilt Cloud, CI mode patterns

- **flux** skill: Manage GitOps Kubernetes deployments with FluxCD sources and Kustomizations
  - 4 reference docs: install-and-setup.md, command-cookbook.md, gitops-sources.md, kustomizations-and-helmreleases.md
  - Content: install flux CLI, flux check --pre, bootstrap github/gitlab, GITHUB_TOKEN/GITLAB_TOKEN, flux check; flux get all/sources/kustomizations/helmreleases, reconcile source/kustomization/helmrelease, suspend/resume, diff, events, logs, create secret, export; GitRepository/HelmRepository/OCIRepository/Bucket CRDs, ImageRepository and ImagePolicy, ImageUpdateAutomation, secret types; Kustomization CRD fields (sourceRef/path/prune/interval/dependsOn/healthChecks/postBuild), HelmRelease CRD fields (chart spec/values/valuesFrom/remediation), dependsOn ordering, multi-tenancy

- **argocd** skill: Deploy Kubernetes apps declaratively with Argo CD applications and projects
  - 4 reference docs: install-and-setup.md, command-cookbook.md, application-management.md, rbac-and-projects.md
  - Content: install CLI, argocd login, ARGOCD_SERVER/ARGOCD_AUTH_TOKEN/ARGOCD_OPTS, initial admin secret, argocd context; argocd app list/get/create/sync/diff/history/rollback/delete/set, cluster/repo/proj/account commands; Application CRD (source/destination/project/syncPolicy), sync waves and hooks, health status states; AppProject CRD, multi-tenancy, RBAC policy syntax, built-in roles, SSO integration, repository credentials

#### Container Runtime Skills (3 new skills)

- **containerd** skill: Manage containers and images with containerd using ctr and nerdctl
  - 4 reference docs: install-and-setup.md, command-cookbook.md, containerd-config.md, kubernetes-integration.md
  - Content: install containerd/nerdctl/CNI plugins/BuildKit, CONTAINERD_ADDRESS/CONTAINERD_NAMESPACE, rootless setup; nerdctl Docker-compatible commands, nerdctl compose, ctr images/containers/tasks/snapshots/content, namespace flag; /etc/containerd/config.toml, CRI plugin section, registry mirrors, snapshotters, SystemdCgroup, containerd config default; containerd as Kubernetes CRI, crictl for pod/container debugging, crictl config, ctr --namespace k8s.io, image GC settings, private registry pull

- **podman** skill: Build and run containers with Podman without a daemon
  - 4 reference docs: install-and-setup.md, command-cookbook.md, rootless-and-pods.md, podman-compose-and-systemd.md
  - Content: install by platform, podman machine init/start/stop/ssh, rootless requirements (subuid/subgid), containers.conf/storage.conf/registries.conf, CONTAINER_HOST; podman run/exec/build/push/pull/pod/network/volume commands, generate kube, play kube, machine commands, system prune; rootless architecture, user namespace mapping, slirp4netns/pasta networking, pod infra container, port publishing, podman-remote, SELinux/AppArmor labels; podman-compose, podman generate systemd, Quadlets (.container/.pod/.network/.volume units), podman auto-update

- **cri-o** skill: Configure and debug CRI-O as a Kubernetes container runtime with crictl
  - 4 reference docs: install-and-setup.md, command-cookbook.md, crio-configuration.md, kubernetes-integration.md
  - Content: install cri-o by platform (OBS apt, dnf/yum), crictl from cri-tools, /etc/crictl.yaml, CONTAINER_RUNTIME_ENDPOINT, crun/runc, CNI plugins, systemctl enable crio; crictl pods/ps/images/pull/exec/logs/inspect/inspecti/inspectp/runp/stopp/rmp/stats/info; /etc/crio/crio.conf and drop-ins, [crio.runtime]/[crio.image]/[crio.network] sections, OCI hooks, seccomp/AppArmor, crio config --default, systemctl reload crio; kubelet CRI socket config, cgroup-driver alignment, Kubernetes version compatibility, CNI plugin config, OCI runtime selection (runc/crun/kata-containers), image storage, GC tuning

#### Secret Management Skills (4 new skills)

- **vault** skill: Manage secrets, tokens, and policies with HashiCorp Vault
  - 4 reference docs: install-and-setup.md, command-cookbook.md, auth-methods.md, policies-and-leases.md
  - Content: Homebrew/APT/binary install, dev server, VAULT_ADDR/VAULT_TOKEN/VAULT_NAMESPACE env vars, .vault-token file, HCL server config; vault login/kv get/put/list/delete/patch, vault read/write, token lookup/renew/revoke, auth list, secrets list, lease renew/revoke, -format=json; AppRole workflow (role_id/secret_id for CI), AWS IAM auth, Kubernetes auth, orphan tokens, env vs file token; HCL policy syntax (path/capabilities), vault policy write/read/list, lease TTL, dynamic secrets concept, KV v1 vs v2 differences, namespace isolation

- **bitwarden-cli** skill: Access and manage Bitwarden vault items via the bw CLI
  - 4 reference docs: install-and-setup.md, command-cookbook.md, auth-and-session.md, item-operations-and-filtering.md
  - Content: NPM/Homebrew/binary install, bw config server for self-hosted, BW_SESSION/BW_CLIENTID/BW_CLIENTSECRET env vars; bw login/logout/unlock/sync/get/list/create/edit/delete commands, --session flag; API key auth, session lifecycle, device trust, scripted CI/CD auth patterns, bw lock; item types (login/securenote/card/identity), bw list filters (folderid/organizationid/collectionid/search/url), JSON templates for create, bulk export, trash/restore, bw encode

- **1password-cli** skill: Access 1Password secrets and run commands via op CLI
  - 4 reference docs: install-and-setup.md, command-cookbook.md, secret-references-and-op-run.md, service-accounts-and-connect.md
  - Content: Homebrew/binary/winget install, op signin, OP_SERVICE_ACCOUNT_TOKEN/OP_CONNECT_HOST/OP_CONNECT_TOKEN env vars, ~/.config/op/config; op signin/item get/list/create/edit/delete/read/run/inject/document get, --format json, --fields flag; op:// secret reference syntax, op run with inline env vars and --env-file, op inject for file templating, GitHub Actions and GitLab CI integration; service account creation/scoping/rotation, 1Password Connect server setup, machine-to-machine auth patterns

- **aws-secretsmanager** skill: Store, retrieve, and rotate secrets with AWS Secrets Manager
  - 4 reference docs: install-and-setup.md, command-cookbook.md, rotation-and-versions.md, access-control-and-iam.md
  - Content: AWS CLI install reference (defer to aws skill), IAM permissions for Secrets Manager, KMS CMK setup, VPC endpoint overview, AWS_REGION/AWS_PROFILE env vars; create-secret/get-secret-value/put-secret-value/update-secret/describe-secret/list-secrets/delete-secret/rotate-secret/tag-resource, --query SecretString jq patterns, multi-region replication; automatic rotation with Lambda, rotation schedules, AWSCURRENT/AWSPENDING/AWSPREVIOUS staging labels, list-secret-version-ids, update-secret-version-stage, built-in rotation functions (RDS/Redshift/DocumentDB), custom Lambda structure, CloudTrail monitoring; least-privilege IAM templates (read-only/manage/rotation Lambda), resource-based policies for cross-account access, KMS key policies, tag-based access control, CloudTrail audit, VPC endpoint

#### Package & Build Manager Skills (10 new skills)

##### Node.js

- **npm** skill: Manage Node.js packages and run scripts with npm
  - 4 reference docs: install-and-setup.md, package-json.md, command-cookbook.md, workspaces.md
  - Content: nvm/fnm/corepack install, .npmrc config, package.json fields (dependencies/devDependencies/peerDependencies/exports/engines/scripts), init/install/ci/run/publish/update/outdated/audit/exec/link/pack commands, --dry-run for publish, workspaces field, --workspace flag, hoisting

- **yarn** skill: Manage JavaScript packages with Yarn Berry (v3/v4) and Classic (v1)
  - 4 reference docs: install-and-setup.md, configuration.md, command-cookbook.md, workspaces.md
  - Content: corepack enable, Classic vs Berry comparison, .yarnrc.yml (Berry) and .yarnrc (Classic), nodeLinker/PnP/node-modules, add/remove/install(--immutable)/run/dlx/up/audit/pack/publish/why/dedupe, workspaces foreach, workspace: protocol, constraints

- **pnpm** skill: Manage Node.js packages efficiently with pnpm's content-addressable store
  - 4 reference docs: install-and-setup.md, configuration.md, command-cookbook.md, workspaces.md
  - Content: corepack/standalone install, pnpm env for Node.js versions, .npmrc (shamefully-hoist/store-dir), pnpm-workspace.yaml, add/remove/install(--frozen-lockfile)/run/dlx/update/outdated/audit/publish/store prune, recursive (-r), --filter, workspace:/catalog: protocols

##### Python

- **pip** skill: Install and manage Python packages with pip inside virtual environments
  - 4 reference docs: install-and-setup.md, requirements-and-indexes.md, command-cookbook.md, virtual-environments.md
  - Content: ensurepip, pip upgrade, pip.conf/pip.ini, requirements.txt format, version specifiers, constraints files, --index-url/--extra-index-url, private PyPI, --require-hashes, install/download/uninstall/freeze/list/show/check/wheel/hash/cache purge, venv creation/activation (bash/fish/PowerShell), pipx for tools

- **poetry** skill: Manage Python dependencies, virtual environments, and package builds with Poetry
  - 4 reference docs: install-and-setup.md, pyproject-toml.md, command-cookbook.md, dependency-groups.md
  - Content: pipx install, POETRY_HOME, [tool.poetry] metadata, version constraints (^/~/*/>=), new/init/add/remove/install/update/show/build/publish/run/shell/env use/export/version commands, dependency groups (--with/--without/--only), group export to requirements.txt

- **pipenv** skill: Manage Python virtual environments and dependencies with Pipenv and Pipfile
  - 4 reference docs: install-and-setup.md, pipfile-and-lockfile.md, command-cookbook.md, environment-management.md
  - Content: pip user/brew install, PIPENV_VENV_IN_PROJECT, Pipfile [[source]]/[packages]/[dev-packages]/[requires], Pipfile.lock, install/uninstall/sync/lock/run/shell/graph/check/clean/update commands, .env auto-loading, PIPENV_PYTHON

##### Java/JVM

- **maven** skill: Build and manage Java projects with Apache Maven lifecycle phases
  - 4 reference docs: install-and-setup.md, pom-xml.md, command-cookbook.md, lifecycle-and-plugins.md
  - Content: brew/apt/sdkman install, Maven wrapper (mvnw), JAVA_HOME, settings.xml, GAV coordinates, dependency scopes, dependencyManagement, profiles, validate/compile/test/package/verify/install/deploy/clean/site phases, dependency:tree, versions plugin, -DskipTests/-B/-T/-pl/-am flags, surefire/failsafe/shade/compiler/resources plugins

- **gradle** skill: Build Java and Android projects with Gradle using the Gradle wrapper
  - 4 reference docs: install-and-setup.md, build-scripts.md, command-cookbook.md, tasks-and-plugins.md
  - Content: sdkman/brew install, Gradle wrapper (./gradlew), gradle init, Groovy vs Kotlin DSL, repositories/dependencies/configurations, settings.gradle, build/test/clean/assemble/check/run/dependencies/tasks commands, -m/--dry-run/--no-daemon/--parallel/--configuration-cache, java/application/spring-boot/maven-publish plugins

##### C/C++

- **make** skill: Automate builds and tasks with GNU Make and Makefiles
  - 4 reference docs: install-and-setup.md, makefile-syntax.md, command-cookbook.md, patterns-and-functions.md
  - Content: brew/apt/xcode-tools install, target/prerequisite/recipe structure (tab indentation), variable flavors (=/:=/?=/+=), automatic variables ($@/$</$^/$*), .PHONY/.DEFAULT_GOAL, make/-n/-j/-f/-C/-B/-k/V=1 flags, static pattern rules, wildcard/patsubst/shell/filter/foreach functions, ifeq/ifdef conditionals

- **cmake** skill: Configure and build C/C++ projects with CMake using out-of-source builds
  - 4 reference docs: install-and-setup.md, cmakelists.md, command-cookbook.md, build-types-and-generators.md
  - Content: brew/apt/pip/winget install, cmake_minimum_required/project()/add_executable/add_library/target_link_libraries/find_package/install(), cmake -S . -B build/-DCMAKE_BUILD_TYPE/--build/--install/ctest/--preset/-G flags, Debug/Release/RelWithDebInfo/MinSizeRel build types, single-config vs multi-config generators, toolchain files, CMakePresets.json

#### Version Manager Skills (6 new skills)

- **nvm** skill: Manage multiple Node.js versions with nvm
  - 4 reference docs: install-and-setup.md, command-cookbook.md, nvmrc-and-defaults.md, shell-integration.md
  - Content: curl/wget installer, shell profile integration, install/use/alias/ls/ls-remote/uninstall/exec commands, .nvmrc project file, default alias, auto-use on cd, lazy-loading pattern, fish shell, Windows alternatives (fnm, nvm-windows)

- **rvm** skill: Manage Ruby versions and gemsets with rvm
  - 4 reference docs: install-and-setup.md, command-cookbook.md, gemsets.md, project-files.md
  - Content: GPG key import, curl installer, rvm requirements, install/use/list/gemset/current/uninstall/remove commands, gemset create/use/delete/@global, .ruby-version, .ruby-gemset, .rvmrc (legacy), autoswitch on cd

- **rbenv** skill: Manage Ruby versions with rbenv and ruby-build
  - 4 reference docs: install-and-setup.md, command-cookbook.md, ruby-build.md, project-files.md
  - Content: Homebrew/rbenv-installer install, shell integration, install/global/local/shell/versions/rehash/uninstall commands, ruby-build plugin, RUBY_CONFIGURE_OPTS, MAKE_OPTS, .ruby-version, shell > local > global precedence, RBENV_VERSION

- **pyenv** skill: Manage multiple Python versions with pyenv
  - 4 reference docs: install-and-setup.md, command-cookbook.md, virtualenvs.md, project-files.md
  - Content: pyenv-installer/Homebrew install, OS build dependencies, install/global/local/shell/versions/which commands, pyenv-virtualenv plugin, virtualenv create/activate/auto-activate, .python-version, PYENV_VERSION, multi-version tox support

- **asdf** skill: Manage multiple language runtime versions with asdf
  - 4 reference docs: install-and-setup.md, command-cookbook.md, plugins-and-tools.md, tool-versions.md
  - Content: git clone/Homebrew install, shell integration for bash/zsh/fish, plugin add/update/remove, install/global/local/shell/current/list/reshim commands, popular plugins (nodejs/python/ruby/golang/java/terraform), .tool-versions format, CI usage (GitHub Actions, generic)

- **direnv** skill: Manage per-directory environment variables with direnv
  - 4 reference docs: install-and-setup.md, command-cookbook.md, envrc-patterns.md, integrations.md
  - Content: apt/brew/nix/binary install, shell hook for bash/zsh/fish, .envrc security model, allow/deny/reload/edit/status/prune/exec commands, export/PATH_add/source_env/layout/use/dotenv patterns, pyenv/nvm/rbenv/asdf integrations, editor integration

#### Infrastructure as Code Skills (4 new skills)

- **terraform** skill: Plan and apply HashiCorp Terraform infrastructure
  - 4 reference docs: install-and-setup.md, configuration.md, command-cookbook.md, state-and-backends.md
  - Content: macOS/Linux/Windows install, tfenv, provider blocks, variables, outputs, backends (S3/GCS/HCP), init/validate/fmt/plan/apply/destroy, state commands (list/show/mv/rm), import, workspaces, state locking, sensitive values

- **open-tofu** skill: Plan and apply OpenTofu (open-source Terraform fork) infrastructure
  - 4 reference docs: install-and-setup.md, configuration.md, command-cookbook.md, migrating-from-terraform.md
  - Content: installer script/apt/rpm/brew/winget install, tofuenv, HCL configuration (identical to Terraform), state encryption (OpenTofu-specific), `tofu test` native testing, provider lock, migration guide from Terraform (state compatibility, license comparison, CI/CD updates, rollback)

- **pulumi** skill: Deploy cloud infrastructure using TypeScript, Python, Go, C#, or YAML
  - 4 reference docs: install-and-setup.md, language-and-project.md, stacks-and-config.md, command-cookbook.md
  - Content: curl/brew/winget install, Pulumi Cloud and self-managed backends, language-specific code examples (TS/Python/Go/C#/YAML), Pulumi.yaml project file, stack operations, config/secrets management, cross-stack references, `pulumi new/preview/up/destroy/refresh/import/convert`

- **ansible** skill: Automate configuration management with agentless SSH automation
  - 4 reference docs: install-and-setup.md, inventory-and-variables.md, playbook-patterns.md, command-cookbook.md
  - Content: pip/apt/dnf/brew install, SSH key setup, ansible.cfg, INI/YAML inventory, group_vars/host_vars, dynamic inventory (AWS EC2/GCP), variable precedence, play structure, common modules table, conditionals/loops/register/tags/roles, ad-hoc commands, `ansible-playbook --check --diff`, ansible-galaxy, ansible-vault, ansible-inventory

#### Atlassian Documentation Lookup Skills (1 new skill)

- **jsm-docs** skill: Navigate Jira Service Management Cloud documentation at support.atlassian.com/jira-service-management and REST API
  - 4 reference docs: navigation.md, quick-reference.md, jsm-cloud-reference.md, api-reference.md
  - Content: JSM Cloud product overview, doc site structure, queue/SLA/portal/request type configuration, ITSM processes (incident/change/problem management), Assets (IT asset management), Knowledge Base integration, JSM REST API endpoints, authentication, pagination, asset management operations

### Improved

#### Skill Inline Examples (42 skills)

- Added a second inline code block to every SKILL.md that previously had only 1 (or 0) code
  examples, satisfying validation rubric criterion V05 (Example Quality)
- Examples cover troubleshooting, error recovery, and secondary workflow scenarios for:
  1password-cli, ansible, asdf, atlassian-cli-docs, aws, aws-secretsmanager, az,
  bitwarden-cli, ci-architecture, cmake, direnv, flux, github-docs, gitlab-docs, glab,
  gradle, helm, jenkins-agent, jenkins-docs, jira-docs, jsm-docs, kubectl, kustomize,
  make, maven, npm, nvm, open-tofu, pip, pipenv, pnpm, poetry, pyenv, rbenv, rovo-docs,
  rvm, skaffold, terraform, tilt, travis-ci-docs, vault, yaml-linting

#### Validation System (merged from llm-shared-skills)

- Replaced stub `validation/rubric.md` with full 8-criterion V01–V08 rubric including
  detailed PASS/WARN/FAIL conditions, "How to Fix" examples, and a report template
- Replaced stub `validation/public-references.md` with 8 prompt engineering standards
  (Specificity, Diverse Examples, Numbered Workflows, Verification, Failure Modes,
  Single Responsibility, Output Format, Context Efficiency) with academic references
- Added `validation/validate-skill.sh` — automated pre-flight emitting structured metrics
  (line count, section count, code block count, Intent Router detection, safety section)
- Updated `AGENTS.md` with full V01–V08 rubric table, scoring thresholds, and V08 checklist
- Fixed `## Reference Files` → `## Intent Router` heading in argocd, containerd, cri-o,
  and podman SKILL.md files to satisfy V02 (Intent Router Completeness)
- All 61 skills validated: 0 lint FAILs, 0 validate-skill.sh WARNs (IR/length)

### Fixed

#### Markdown Lint (2,758 violations resolved)

- Auto-fixed MD031/MD022/MD032/MD010/MD012/MD026/MD047 across all files (blanks around fences/headings/lists, hard tabs, multiple blanks, trailing punctuation, trailing newline)
- Added language specifiers to 11 bare fenced code blocks in 9 files (`text`, `go`)
- Fixed compact table separator rows (`|---|` → `| --- |`) in 11 files
- Fixed `CLAUDE.md` missing top-level H1 heading (MD041)
- Escaped inline HTML in `skills/az/references/install-and-setup.md` (MD033)
- Added `.markdownlint.json` for local linting (`MD013` disabled, `MD024` siblings-only, `MD060` disabled)
- Updated `.markdownlint-cli2.jsonc` (CI): enabled previously-suppressed rules now clean, changed `no-duplicate-heading` from `false` to `{ siblings_only: true }`

## [0.0.1] - 2026-03-10

### Added

#### Platform CI/CD Workflow Skills (8 new skills)

- **gitlab-ci** skill: Write and maintain GitLab CI pipelines
  - 4 reference docs: pipeline-basics.md, runners-and-caching.md, testing-and-quality.md, variables-and-secrets.md
  - Content: `.gitlab-ci.yml` structure, job anatomy, stages, runners, caching, artifacts, testing, quality gates, variables, secrets, CI variables, OIDC tokens

- **gitlab-cd** skill: Deploy with GitLab CD environments and pipelines
  - 4 reference docs: environments-and-deployments.md, deployment-targets.md, review-apps.md, release-and-versioning.md
  - Content: Environment keyword, deployment tiers, protection rules, Kubernetes/AWS/GCP/Heroku deployments, review apps, releases, package registries

- **github-ci** skill: Write and maintain GitHub Actions CI workflows
  - 4 reference docs: workflow-basics.md, runners-and-caching.md, testing-patterns.md, security-and-secrets.md
  - Content: Workflow YAML, event triggers, job anatomy, GitHub-hosted/self-hosted runners, matrix testing, caching, testing, code coverage, secrets, permissions

- **github-cd** skill: Deploy with GitHub Actions CD workflows and OIDC
  - 4 reference docs: environments-and-protection.md, cloud-deployments.md, oidc-and-auth.md, releases-and-packages.md
  - Content: Environment protection, deployment approval, OIDC authentication, AWS/GCP/Azure/Kubernetes deployments, releases, container registries, artifact signing

- **jenkins-ci** skill: Write Jenkins Declarative Pipeline CI stages
  - 4 reference docs: declarative-pipeline.md, agents-and-workspaces.md, testing-and-reporting.md, shared-libraries.md
  - Content: Declarative Pipeline structure, agent types, stages, steps, post conditions, parameters, tools, when conditions, testing, reporting, shared libraries

- **jenkins-cd** skill: Deploy applications with Jenkins Pipeline stages
  - 4 reference docs: deployment-stages.md, credentials-and-secrets.md, deployment-targets.md, strategies-and-rollback.md
  - Content: Deployment stages, input approval, locking, credentials management, Kubernetes/AWS/Docker deployments, blue-green/canary strategies, rollback patterns

- **travis-ci** skill: Write and maintain Travis CI build configuration
  - 4 reference docs: build-lifecycle.md, matrix-and-environments.md, testing-patterns.md, caching-strategies.md
  - Content: Build phases, language matrix, OS variants, environment variables, conditional builds, testing, caching, Docker layer caching

- **travis-cd** skill: Deploy from Travis CI to cloud and registries
  - 4 reference docs: deployment-providers.md, deployment-conditions.md, credential-management.md, release-automation.md
  - Content: Deployment providers (Heroku, AWS S3, npm, PyPI, Docker, GitHub), conditional deployment, encrypted credentials, semantic versioning, releases

#### Platform Runner/Agent Management Skills (4 new skills)

- **gitlab-runner** skill: Install and manage GitLab Runner daemons
  - 4 reference docs: installation.md, registration-and-config.md, executors.md, operations.md
  - Content: Installation on Linux/Docker/Kubernetes/macOS/Windows, runner registration, auth tokens, config.toml anatomy, executor types (Shell, Docker, Kubernetes, SSH), health monitoring, log management, troubleshooting

- **github-runner** skill: Install and manage GitHub Actions self-hosted runners
  - 4 reference docs: installation.md, registration-and-config.md, arc-and-scaling.md, operations.md
  - Content: Runner installation on Linux/macOS/Windows/Docker, JNLP launch, registration tokens, runner labels/groups, Actions Runner Controller (ARC) on Kubernetes, ephemeral runners, auto-scaling, operations

- **jenkins-agent** skill: Install and manage Jenkins agents and nodes
  - 4 reference docs: agent-types.md, installation-and-connection.md, cloud-and-dynamic-agents.md, operations.md
  - Content: Agent types (SSH, JNLP, WebSocket JNLP, Docker Cloud, Kubernetes, built-in), agent.jar installation, SSH key setup, JNLP launch, Docker Cloud plugin, Kubernetes plugin with pod templates, CASC, operations

- **travis-worker** skill: Configure Travis CI SaaS environments and manage travis-worker daemon
  - 4 reference docs: saas-build-environments.md, enterprise-installation.md, enterprise-configuration.md, operations.md
  - Content: SaaS environment selection (OS, dist, arch), package/container installation, custom build images, RabbitMQ connection, pool sizing, resource limits, worker groups, enterprise configuration, monitoring

#### Platform Documentation Lookup Skills

- **gitlab-docs** skill: Navigate docs.gitlab.com for CI/CD, runners, API, administration docs via WebFetch
- **github-docs** skill: Navigate docs.github.com/en for Actions, REST API, Packages, Security docs via WebFetch
- **jenkins-docs** skill: Navigate jenkins.io/doc for Declarative Pipeline, Shared Libraries, plugins, steps via WebFetch
- **travis-ci-docs** skill: Navigate docs.travis-ci.com for .travis.yml reference, build stages, deployment via WebFetch

#### Atlassian Documentation Lookup Skills (3 new skills)

- **jira-docs** skill: Navigate Jira Cloud documentation at support.atlassian.com/jira-software-cloud and REST API v3
  - 4 reference docs: navigation.md, quick-reference.md, jira-cloud-reference.md, api-reference.md
  - Content: Jira Cloud product family overview, doc site structure, board/sprint/workflow/issue configuration, JQL syntax, REST API v3 endpoints, authentication, pagination, rate limiting

- **atlassian-cli-docs** skill: Navigate Atlassian CLI (ACLI) documentation at developer.atlassian.com/cloud/acli
  - 4 reference docs: navigation.md, quick-reference.md, command-reference.md, ci-integration.md
  - Content: ACLI guides, installation, command tree (admin, jira, rovodev subcommands), CI pipeline integration patterns, output formatting, command chaining

- **rovo-docs** skill: Navigate Atlassian Rovo documentation at support.atlassian.com/rovo
  - 4 reference docs: navigation.md, quick-reference.md, rovo-dev-reference.md, agents-and-governance.md
  - Content: Rovo Search/Chat/Agents features, Rovo Dev CLI commands, MCP server integration, IDE support (VS Code, Cursor), agent creation and governance, org administration

#### Architecture & Best Practices

- **ci-architecture** skill: Design CI/CD pipelines using proven best practices (DORA metrics, DevSecOps, SLSA framework, platform engineering patterns)
  - 4 reference docs: pipeline-design.md, security-practices.md, deployment-patterns.md, measurement.md
  - Content: Canonical pipeline stages, test pyramid, branching strategies, artifact management, deployment patterns (blue-green, canary, rolling, GitOps, IaC), security practices, DORA metrics, observability, incident recovery

#### Cloud & General CLI Tools (4 skills migrated from llm-shared-skills)

- **docker** skill: Build, run, and manage Docker containers and images
  - 10 reference files + scripts and assets
  - Content: Dockerfile authoring, image building, container lifecycle, networking, volumes, Docker Compose, registry operations, multi-stage builds, security best practices
  - Cross-platform coverage: Linux, macOS, Windows, WSL2

- **aws** skill: AWS CLI for cloud infrastructure operations
  - 5 reference files + scripts
  - Content: EC2, S3, CloudFormation, IAM, ECS, deployment patterns, credential management
  - Cross-platform coverage: Linux, macOS, Windows, WSL2

- **az** skill: Azure CLI for Azure resource management
  - 5 reference files + scripts
  - Content: Resource groups, VMs, container registries, AKS, app service deployments
  - Cross-platform coverage: Linux, macOS, Windows, WSL2

- **glab** skill: GitLab CLI for repository and pipeline operations
  - 5 reference files + scripts
  - Content: Issues, merge requests, pipelines, variables, CI/CD operations, authentication

### Previously Added

- yaml-linting skill: Docker-based YAML linting with yamllint (pipelinecomponents/yamllint)
- yaml-lsp skill: YAML Language Server in Docker for editor integration (node:lts-alpine + npm)
- Initial plugin scaffold for CI/CD skills collection
- Repository structure and documentation templates
- Installation guides for Claude Code and Codex
- AGENTS.md guidance for skill development
- Linting system imported from llm-shared-skills with 12 validation rules (L01-L12)
- Markdownlint configuration aligned with skill standards

---

## [0.1.0] - 2026-03-10

### Added

- Initial repository setup with plugin scaffolding
- Configuration files for Claude Code and Codex integration
- Documentation framework for skills
