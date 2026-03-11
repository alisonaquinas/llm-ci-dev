# asdf Command Cookbook

## Plugins

```bash
# Add a plugin from the asdf plugin registry
asdf plugin add nodejs
asdf plugin add python
asdf plugin add ruby

# Add a plugin from a custom URL
asdf plugin add my-tool https://github.com/org/asdf-my-tool.git

# List installed plugins
asdf plugin list

# List all available plugins in the registry
asdf plugin list all

# Update a plugin to its latest version
asdf plugin update nodejs

# Update all plugins
asdf plugin update --all

# Remove a plugin (and all its installed versions)
asdf plugin remove nodejs
```

## Install Versions

```bash
# List installable versions for a plugin
asdf list all nodejs

# Install a specific version
asdf install nodejs 20.14.0

# Install the version specified in .tool-versions
asdf install
```

## Set Versions

```bash
# Set global default (writes ~/.tool-versions)
asdf global nodejs 20.14.0

# Pin for current directory (writes ./.tool-versions)
asdf local nodejs 20.14.0

# Set for current shell session only
asdf shell nodejs 20.14.0
```

## Inspect Active Versions

```bash
# Show active version for all tools
asdf current

# Show active version for a specific tool
asdf current nodejs

# List installed versions for a tool (* = active)
asdf list nodejs

# Show the full path to the active binary
asdf which node
```

## Reshim

After installing packages that provide CLI binaries, regenerate shims:

```bash
# Reshim after npm install -g
asdf reshim nodejs

# Reshim all tools
asdf reshim
```

## Uninstall

```bash
# Remove a specific version
asdf uninstall nodejs 18.20.3
```
