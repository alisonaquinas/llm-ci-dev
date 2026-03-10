# Environment Management — Pipenv

## PIPENV_VENV_IN_PROJECT

By default, Pipenv stores virtual environments in a global cache directory. Setting
`PIPENV_VENV_IN_PROJECT=1` places the environment in `.venv/` inside the project:

```bash
export PIPENV_VENV_IN_PROJECT=1
pipenv install
# venv now at .venv/ relative to project root
```

Add `.venv/` to `.gitignore` when using this mode.

## Automatic .env File Loading

Pipenv automatically loads a `.env` file in the project root whenever `pipenv run`
or `pipenv shell` is invoked. No extra configuration is required.

```
# .env
DATABASE_URL=postgres://localhost/mydb
SECRET_KEY=dev-secret
```

Variables are injected into the environment for the duration of the command.

## Using Environment Variables Inside Pipfile

Reference shell or `.env` variables in `Pipfile` using `${VAR}` syntax:

```toml
[[source]]
url = "https://${PYPI_TOKEN}@private.pypi.example.com/simple"
```

## PIPENV_PYTHON Environment Variable

Set the default Python interpreter without passing `--python` on every command:

```bash
export PIPENV_PYTHON=python3.11
```

## Selecting a Python Version

```bash
pipenv --python 3.11
pipenv --python /usr/local/bin/python3.12
```

The chosen version is recorded in `Pipfile` under `[requires]`.

## Inspecting the Virtual Environment

```bash
# Path to the virtual environment directory
pipenv --venv

# Path to the Python interpreter
pipenv --py

# Project root directory
pipenv --where
```

## Deactivating the Shell

Exit an activated `pipenv shell` session with:

```bash
exit
```

The parent shell's environment is restored automatically.

## Removing the Virtual Environment

```bash
pipenv --rm
```

This deletes the virtual environment directory. Running `pipenv install` afterwards
creates a fresh environment from `Pipfile.lock`.

## Dev vs. Runtime Separation

The `--dev` flag controls which packages are installed in a given context:

```bash
# Install runtime only (e.g., production)
pipenv sync

# Install runtime + dev packages (e.g., local development, CI testing)
pipenv sync --dev
```
