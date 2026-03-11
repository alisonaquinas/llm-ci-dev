# Installation Guide

## For Claude Code Users

### Option 1: Add as a Local Plugin (Recommended)

1. Add the repository path to your `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "llm-ci-cd-skills@local": true
  },
  "pluginDirs": [
    "/path/to/llm-ci-cd-skills"
  ]
}
```

Restart Claude Code, and the skills will be automatically loaded.

### Option 2: Clone into Your Local Plugins Directory

```bash
mkdir -p ~/.claude/plugins
git clone <repo-url> ~/.claude/plugins/llm-ci-cd-skills
```

Then add to your `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "llm-ci-cd-skills@local": true
  }
}
```

## For Codex Users (OpenAI Agent)

Codex uses a different mechanism. Create symlinks or directory junctions in `~/.codex/skills/`:

### macOS/Linux

```bash
mkdir -p ~/.codex/skills
cd ~/.codex/skills

# For each skill, create a symlink
ln -s /path/to/llm-ci-cd-skills/skills/<skill-name> <skill-name>
```

### Windows (PowerShell)

```powershell
mkdir -Path $env:USERPROFILE\.codex\skills -Force

$skillsRepo = "C:\path\to\llm-ci-cd-skills\skills"
$codexSkillsDir = "$env:USERPROFILE\.codex\skills"

# For each skill, create a directory junction
$skills = @(
    # Platform CI/CD Workflow Skills
    "gitlab-ci", "gitlab-cd",
    "github-ci", "github-cd",
    "jenkins-ci", "jenkins-cd",
    "travis-ci", "travis-cd",
    # Platform Runner/Agent Management Skills
    "gitlab-runner", "github-runner", "jenkins-agent", "travis-worker",
    # Cloud & General CLI Tools
    "docker", "aws", "az", "glab",
    # Documentation Lookup Skills
    "gitlab-docs", "github-docs", "jenkins-docs", "travis-ci-docs",
    "jira-docs", "jsm-docs", "atlassian-cli-docs", "rovo-docs",
    # Architecture & Utilities
    "ci-architecture", "yaml-linting", "yaml-lsp"
)

foreach ($skill in $skills) {
    New-Item -ItemType Junction -Path "$codexSkillsDir\$skill" -Target "$skillsRepo\$skill" -Force
}
```

## Verifying Installation

After installation, restart your agent tool:

- **Claude Code:** Restart the CLI or reload the IDE extension
- **Codex:** Reload the Codex agent

You should now be able to trigger skills by name (e.g., `$gitlab-docs`, `$github-docs`, `$ci-architecture`).

## Troubleshooting

### Skills not appearing in Claude Code

- Verify the plugin path exists and contains a `.claude-plugin/plugin.json`
- Check that `enabledPlugins` references the correct plugin name
- Clear any cached plugin data (depends on IDE/client)

### Symlinks not working on Windows

- Ensure you're running PowerShell **as Administrator**
- If using WSL, prefer bash symlinks inside WSL over Windows directory junctions
- Verify the target skill directory exists and contains `SKILL.md`

## Next Steps

Once installed, refer to individual skill documentation for usage examples.
See [README.md](README.md) for the complete skill list and descriptions.

### Recommended Usage

- **Start with platform workflow skills** — Use `$gitlab-ci`, `$github-ci`, `$jenkins-ci`, or `$travis-ci` to learn how to write CI/CD pipelines
- **Runner/agent management** — Use `$gitlab-runner`, `$github-runner`, `$jenkins-agent`, or `$travis-worker` to configure self-hosted infrastructure
- **Cloud CLI tools** — Use `$docker`, `$aws`, `$az`, or `$glab` for infrastructure and deployment operations
- **Reference documentation skills** — Load `$gitlab-docs`, `$github-docs`, `$jira-docs`, `$jsm-docs`, etc. for syntax details and version-specific information
- **Design patterns** — Consult `$ci-architecture` for pipeline design principles, security, and deployment strategies
- **Utility skills** — Use `$yaml-linting` and `$yaml-lsp` for validating and editing YAML files

Each platform skill contains 4 reference documents accessible via the Intent Router. Load them on demand for specific topics.
