# pip — Virtual Environments

## Create a Virtual Environment

```bash
# Create a venv in the .venv directory (standard practice)
python -m venv .venv

# Create with access to system site-packages (uncommon; avoid for isolation)
python -m venv --system-site-packages .venv

# Upgrade pip, setuptools, and wheel immediately after creation
python -m venv .venv && .venv/bin/pip install --upgrade pip setuptools wheel
```

## Activation Scripts

Activate the venv to make `python` and `pip` point to the venv binaries:

```bash
# bash / zsh
source .venv/bin/activate

# fish
source .venv/bin/activate.fish

# csh / tcsh
source .venv/bin/activate.csh
```

```powershell
# PowerShell (Windows)
.venv\Scripts\Activate.ps1

# cmd.exe (Windows)
.venv\Scripts\activate.bat
```

After activation, the shell prompt typically shows `(.venv)` and `which python` / `where python` points to the venv.

## Deactivation

```bash
deactivate
```

This restores the original shell PATH. The venv itself is unaffected.

## Locating site-packages

```bash
python -c "import site; print(site.getsitepackages())"
```

Installed packages live in `.venv/lib/pythonX.Y/site-packages/` on Unix and `.venv\Lib\site-packages\` on Windows.

## --user Installs

`pip install --user` installs into the user's home directory (~/.local/) without requiring sudo:

```bash
pip install --user black
```

Avoid `--user` installs when a virtual environment is active — the `--user` flag is ignored in that context and the package goes to the system user directory instead, causing confusion.

Prefer activating a venv over `--user` for all project work.

## pipx — CLI Tools in Isolated Environments

pipx installs CLI tools in their own dedicated virtual environments, keeping them isolated from each other and from project dependencies:

```bash
# Install pipx
pip install --user pipx
pipx ensurepath

# Install a CLI tool
pipx install black
pipx install ruff
pipx install httpie

# Run a tool without installing it
pipx run cowsay "hello"

# Upgrade all installed tools
pipx upgrade-all

# List installed tools
pipx list
```

pipx is the recommended way to install tools like `black`, `ruff`, `mypy`, `pre-commit`, and `twine` system-wide.

## System Python vs User Python

| Context           | Recommendation                                    |
|-------------------|---------------------------------------------------|
| Project work      | Always use a project-level venv                   |
| CLI tools         | Use pipx                                          |
| CI/CD             | Create a fresh venv; cache with pip's cache dir   |
| System packages   | Never modify with pip; use the OS package manager |

Modifying the system Python with pip can break OS tooling that depends on it.
