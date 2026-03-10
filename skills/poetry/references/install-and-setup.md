# Install and Setup — Poetry

## Recommended: Install via pipx

`pipx` installs Poetry into an isolated environment so it never conflicts with project dependencies.

```bash
pipx install poetry
```

To upgrade later:

```bash
pipx upgrade poetry
```

## Official Installer

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

The installer places the `poetry` binary in `$POETRY_HOME/bin` (default: `~/.local/share/pypoetry`).
Add that directory to `PATH` if not already present.

## POETRY_HOME Environment Variable

Override the installation directory by setting `POETRY_HOME` before running the installer:

```bash
export POETRY_HOME=/opt/poetry
curl -sSL https://install.python-poetry.org | python3 -
```

## Check Installed Version

```bash
poetry --version
```

## Update Poetry

```bash
poetry self update
```

Pin to a specific version:

```bash
poetry self update 1.8.0
```

## Shell Completions

Generate completions for the current shell:

```bash
# Bash
poetry completions bash >> ~/.bash_completion

# Zsh
poetry completions zsh > ~/.zfunc/_poetry

# Fish
poetry completions fish > ~/.config/fish/completions/poetry.fish
```

Reload the shell after adding completions.

## Configuration Defaults

List current configuration:

```bash
poetry config --list
```

Store virtual environments inside the project directory:

```bash
poetry config virtualenvs.in-project true
```
