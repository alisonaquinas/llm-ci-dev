# asdf Plugins and Tools

## Finding Plugins

The community-maintained plugin registry is at <https://github.com/asdf-vm/asdf-plugins>.

```bash
# Search available plugins
asdf plugin list all | grep python
asdf plugin list all | grep java
```

## Popular Plugins

| Plugin | Add command | Notes |
| --- | --- | --- |
| Node.js | `asdf plugin add nodejs` | Requires GnuPG for signature verification |
| Python | `asdf plugin add python` | Requires OS build deps (see pyenv install-and-setup) |
| Ruby | `asdf plugin add ruby` | Requires OS build deps |
| Go | `asdf plugin add golang` | Downloads pre-built binaries |
| Java | `asdf plugin add java` | Supports OpenJDK, GraalVM, etc. |
| Terraform | `asdf plugin add terraform` | Downloads HashiCorp release |
| kubectl | `asdf plugin add kubectl` | Kubernetes CLI |
| Helm | `asdf plugin add helm` | Kubernetes package manager |
| direnv | `asdf plugin add direnv` | Environment manager |

## Plugin Lifecycle

```bash
# 1. Add the plugin
asdf plugin add nodejs

# 2. List available versions
asdf list all nodejs | tail -20

# 3. Install a version
asdf install nodejs 20.14.0

# 4. Set global or local version
asdf global nodejs 20.14.0

# 5. Verify
node --version

# 6. Update the plugin later
asdf plugin update nodejs
```

## Node.js Plugin: GPG Key Requirement

The Node.js plugin verifies downloaded binaries with GPG. Import the Node.js release keys:

```bash
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
```

Or disable verification (not recommended for production):

```bash
export NODEJS_CHECK_SIGNATURES=no
```

## Custom / Private Plugins

Any Git repository implementing the asdf plugin API can be used:

```bash
asdf plugin add custom-tool https://github.com/myorg/asdf-custom-tool.git
```

The plugin repository must contain `bin/list-all`, `bin/download`, and `bin/install` scripts following the asdf plugin spec at <https://asdf-vm.com/plugins/create.html>.
