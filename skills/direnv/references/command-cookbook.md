# direnv Command Cookbook

## Allow and Deny

```bash
# Allow the .envrc in the current directory
direnv allow

# Allow a .envrc in a specific path
direnv allow /path/to/project

# Revoke permission for the current directory
direnv deny

# Revoke permission for a specific path
direnv deny /path/to/project
```

## Reload

```bash
# Reload the current .envrc (equivalent to leaving and re-entering the directory)
direnv reload
```

Direnv also reloads automatically when the `.envrc` file changes and the shell hook is active.

## Edit

```bash
# Open .envrc in $EDITOR and allow it automatically after saving
direnv edit .

# Edit a specific path
direnv edit /path/to/project
```

Using `direnv edit` instead of a plain editor call ensures the file is re-allowed immediately after saving.

## Status

```bash
# Show status: loaded file, export count, allowed state
direnv status
```

Example output:

```
direnv exec path /path/to/project
Found RC path /path/to/project/.envrc
Found watch path /path/to/project/.envrc
Loaded watch path
Allowed true
```

## Prune

```bash
# Remove allow entries for directories that no longer exist
direnv prune
```

Run this periodically to clean up the allowed list after removing old project directories.

## Exec

```bash
# Run a command in the context of a directory's .envrc without switching directories
direnv exec /path/to/project env | grep MY_VAR
direnv exec /path/to/project ./script.sh
```

## Useful One-Liners

```bash
# Check what environment variables an .envrc exports
direnv exec . env

# Temporarily unload direnv for the current shell session
unset DIRENV_DIR
```
