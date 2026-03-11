# direnv Integrations

## pyenv

direnv provides a `layout pyenv` helper that activates a pyenv-managed Python and creates an isolated virtualenv:

```bash
# .envrc
layout pyenv 3.12.3
```

This creates a virtualenv in `.direnv/python-3.12.3/` and activates it automatically. Requires pyenv and pyenv-virtualenv to be installed.

Alternatively, use `use python` with a `.python-version` file:

```bash
# .envrc
use python   # reads .python-version
```

## nvm

nvm must be loaded before direnv can use it:

```bash
# .envrc — source nvm first, then use it
source_env_if_exists "$HOME/.nvm/nvm.sh"
nvm use   # reads .nvmrc
```

Or use the `use nvm` stdlib command (available in newer direnv versions):

```bash
# .envrc
use nvm 20
```

## rbenv

```bash
# .envrc
use ruby   # reads .ruby-version via rbenv
```

Or explicitly:

```bash
# .envrc
layout ruby
```

`layout ruby` sets `GEM_HOME`, `GEM_PATH`, and updates `PATH` to use the project gemset.

## asdf

The `use asdf` command reads `.tool-versions` and activates all listed tool versions:

```bash
# .envrc
use asdf
```

This is equivalent to running `asdf install` and `asdf local` for each tool, but without modifying `.tool-versions`. All tools listed in `.tool-versions` are available in the directory.

## dotenv Files

Load a `.env` file (12-factor style) alongside other configuration:

```bash
# .envrc
dotenv          # loads .env
dotenv_if_exists .env.local   # loads .env.local if it exists
```

Variables in `.env` do not need `export` — direnv exports them automatically. Keep `.env.local` in `.gitignore` and share `.env.example` with placeholder values.

## Editor Integration

| Editor | Plugin / Extension |
| --- | --- |
| VS Code | [direnv extension](https://marketplace.visualstudio.com/items?itemName=mkhl.direnv) — loads `.envrc` into the editor's environment |
| Emacs | `envrc.el` — uses `direnv` to load `.envrc` per buffer |
| Neovim / Vim | `direnv.vim` — calls `direnv export` on directory change |
| IntelliJ IDEs | Load the `.env` file via the EnvFile plugin alongside direnv |

For editor integration troubleshooting, see: <https://direnv.net/docs/editor-integration.html>

## Advanced Usage

For comprehensive stdlib reference including `watch_file`, `source_url`, `has`, and other helpers, see: <https://direnv.net/man/direnv-stdlib.1.html>
