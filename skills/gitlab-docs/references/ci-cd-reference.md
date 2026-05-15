# GitLab CI/CD Full Reference

Complete breakdown of the GitLab CI/CD section (docs.gitlab.com/ci/).

## Pipeline Basics

| Concept | Documentation URL |
| --- | --- |
| Pipelines overview | `https://docs.gitlab.com/ci/pipelines/` |
| Pipeline types (basic, DAG, parent-child) | `https://docs.gitlab.com/ci/pipelines/pipeline_architectures.html` |
| Stages and jobs | `https://docs.gitlab.com/ci/yaml/#stages` |
| Jobs and runners | `https://docs.gitlab.com/ci/jobs/` |
| Pipeline status and badges | `https://docs.gitlab.com/ci/pipelines/settings.html` |

## Configuration (.gitlab-ci.yml)

| Keyword/Concept | Documentation URL |
| --- | --- |
| Full `.gitlab-ci.yml` reference | `https://docs.gitlab.com/ci/yaml/` |
| `rules` keyword (conditional execution) | `https://docs.gitlab.com/ci/yaml/#rules` |
| `needs` keyword (job dependencies) | `https://docs.gitlab.com/ci/yaml/#needs` |
| `extends` keyword (job templates) | `https://docs.gitlab.com/ci/yaml/#extends` |
| `trigger` keyword (child pipelines) | `https://docs.gitlab.com/ci/yaml/#trigger` |
| `artifacts` — retention and reports | `https://docs.gitlab.com/ci/yaml/#artifacts` |
| `cache` — dependency caching | `https://docs.gitlab.com/ci/yaml/#cache` |
| `variables` — environment variables | `https://docs.gitlab.com/ci/yaml/#variables` |
| `environment` — deployment environments | `https://docs.gitlab.com/ci/yaml/#environment` |
| `retry` — job retry policy | `https://docs.gitlab.com/ci/yaml/#retry` |
| `timeout` — job timeout | `https://docs.gitlab.com/ci/yaml/#timeout` |
| `image` — job container image | `https://docs.gitlab.com/ci/yaml/#image` |
| `services` — service containers | `https://docs.gitlab.com/ci/yaml/#services` |
| `only` / `except` — deprecated, migrate to `rules:` | `https://docs.gitlab.com/ci/yaml/#only--except` |
| Migration: `only`/`except` → `rules:` | `https://docs.gitlab.com/ci/yaml/#rules` |
| `include` — pipeline composition (local / project / template / remote / component) | `https://docs.gitlab.com/ci/yaml/#include` |
| `inputs` and `spec:inputs:` — typed inputs for includes/components | `https://docs.gitlab.com/ci/yaml/inputs/` |
| `trigger:strategy` — wait, depend, mirror, or fire-and-forget child pipelines | `https://docs.gitlab.com/ci/yaml/#triggerstrategy` |
| `id_tokens` — OIDC ID tokens for jobs | `https://docs.gitlab.com/ci/yaml/#id_tokens` |
| `hooks:pre_get_sources_script` — script before repo clone | `https://docs.gitlab.com/ci/yaml/#hookspre_get_sources_script` |

## Pipeline Triggers & Flow

| Feature | Documentation URL |
| --- | --- |
| Pipeline triggers | `https://docs.gitlab.com/ci/triggers/` |
| Merge request pipelines | `https://docs.gitlab.com/ci/merge_request_pipelines/` |
| Push pipelines | `https://docs.gitlab.com/ci/pipelines/#types` |
| Scheduled pipelines | `https://docs.gitlab.com/ci/pipelines/schedules.html` |
| Manual pipeline triggers | `https://docs.gitlab.com/ci/pipelines/index.html#creating-pipelines` |

## Variables & Secrets

| Topic | Documentation URL |
| --- | --- |
| Predefined variables (CI_PIPELINE_ID, CI_PROJECT_NAME, etc.) | `https://docs.gitlab.com/ci/variables/predefined_variables.html` |
| Custom CI/CD variables (project, group, instance) | `https://docs.gitlab.com/ci/variables/` |
| Protected variables | `https://docs.gitlab.com/ci/variables/#protect-a-cicd-variable` |
| Masked variables | `https://docs.gitlab.com/ci/variables/#mask-a-cicd-variable` |
| Credential management patterns | `https://docs.gitlab.com/ci/secrets/` |

## Runners & Execution

| Topic | Documentation URL |
| --- | --- |
| Runners overview and types | `https://docs.gitlab.com/ci/runners/` |
| Runner installation | `https://docs.gitlab.com/runner/install/` |
| Runner configuration | `https://docs.gitlab.com/runner/configuration/advanced-configuration.html` |
| Executors (Docker, Shell, Kubernetes, etc.) | `https://docs.gitlab.com/runner/executors/` |
| Runner autoscaling | `https://docs.gitlab.com/runner/runners/autoscale/` |
| Caching with runners | `https://docs.gitlab.com/ci/caching/` |

## Artifacts & Reports

| Topic | Documentation URL |
| --- | --- |
| Artifacts overview | `https://docs.gitlab.com/ci/artifacts/` |
| Artifact retention policies | `https://docs.gitlab.com/ci/artifacts/#keep-artifacts-from-expiring` |
| Test reports (JUnit, etc.) | `https://docs.gitlab.com/ci/yaml/#artifactsreports` |
| Coverage reports | `https://docs.gitlab.com/ci/yaml/#artifactsreportscoverage_report` |
| Performance reports | `https://docs.gitlab.com/ci/yaml/#artifactsreportsperformance` |

## Security & Scanning

| Topic | Documentation URL |
| --- | --- |
| SAST (Static Application Security Testing) | `https://docs.gitlab.com/user/application_security/sast/` |
| Dependency scanning | `https://docs.gitlab.com/user/application_security/dependency_scanning/` |
| Container scanning | `https://docs.gitlab.com/user/application_security/container_scanning/` |
| DAST (Dynamic Application Security Testing) | `https://docs.gitlab.com/user/application_security/dast/` |
| Secret detection | `https://docs.gitlab.com/user/application_security/secret_detection/` |
| Infrastructure as Code (IaC) scanning | `https://docs.gitlab.com/user/application_security/iac_scanning/` |

## CI Job Token & Fine-Grained Permissions

| Topic | Documentation URL |
| --- | --- |
| CI job token overview | `https://docs.gitlab.com/ci/jobs/ci_job_token/` |
| Fine-grained job token permissions (granular REST API allowlist) | `https://docs.gitlab.com/ci/jobs/fine_grained_permissions/` |
| Control job-token access between projects | `https://docs.gitlab.com/ci/jobs/ci_job_token/#control-job-token-access-to-your-project` |
| Push commits to the project repo via job token | `https://docs.gitlab.com/ci/jobs/ci_job_token/#push-to-the-project-repository` |
| Migration from registration to authentication tokens for runners | `https://docs.gitlab.com/ci/runners/new_creation_workflow/` |

## Container Registry & Supply Chain

| Topic | Documentation URL |
| --- | --- |
| Container registry overview | `https://docs.gitlab.com/user/packages/container_registry/` |
| Immutable container tags | `https://docs.gitlab.com/user/packages/container_registry/immutable_container_tags/` |
| Protected container repositories | `https://docs.gitlab.com/user/packages/container_registry/container_repository_protection_rules/` |
| SLSA build provenance for CI artifacts | `https://docs.gitlab.com/ci/runners/configure_runners/#artifacts-attestation` |

## Templates & CI/CD Catalog

| Topic | Documentation URL |
| --- | --- |
| CI/CD templates catalog | `https://docs.gitlab.com/ci/templates/` |
| GitLab-provided templates | `https://docs.gitlab.com/ci/yaml/` (search for "Templates") |
| CI/CD component catalog | `https://docs.gitlab.com/ci/components/` |
| Creating reusable components | `https://docs.gitlab.com/ci/components/#creating-a-component` |

## Debugging & Optimization

| Topic | Documentation URL |
| --- | --- |
| Pipeline debugging | `https://docs.gitlab.com/ci/pipelines/debug.html` |
| Job logs and artifacts | `https://docs.gitlab.com/ci/jobs/#viewing-job-details` |
| Performance tuning | `https://docs.gitlab.com/ci/optimization/` |
| Caching strategies | `https://docs.gitlab.com/ci/caching/` |
