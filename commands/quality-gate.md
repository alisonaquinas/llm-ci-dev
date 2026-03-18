# CI/CD quality gate

Run the CI/CD quality gate for `llm-ci-dev`.

You can use this flow in either skill or repository mode:

- If you pass a skill name, run:
  - `python scripts/lint_skills.py <skill-name>`
  - `python scripts/validate_skills.py <skill-name>`
- If you pass no skill name, run:
  - `make lint`
  - `make test`
- For broader release-ready validation, also run:
  - `make build`
  - `make verify`
