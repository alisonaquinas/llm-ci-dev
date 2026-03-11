# Bitwarden CLI Command Cookbook

## Authentication

```bash
# Interactive login (email + master password)
bw login user@example.com

# Headless login using API key
bw login --apikey
# Uses BW_CLIENTID and BW_CLIENTSECRET environment variables

# Logout
bw logout
```

## Session Management

```bash
# Unlock vault and capture session key (one-liner for scripts)
export BW_SESSION=$(bw unlock --raw)

# Alternatively, unlock interactively and export the printed key
bw unlock
export BW_SESSION="<paste-key-here>"

# Lock the vault (clears in-memory keys)
bw lock

# Check login status
bw status
```

## Syncing

```bash
# Pull latest vault data from server
bw sync

# Check last sync time
bw sync --last
```

## Getting Secrets

```bash
# Get a full item by name or ID (returns JSON)
bw get item "My App Login"
bw get item "<uuid>"

# Get just the password field
bw get password "My App Login"

# Get just the username field
bw get username "My App Login"

# Get secure notes content
bw get notes "My Secure Note"

# Get a TOTP code
bw get totp "My App Login"

# Pass session key explicitly (bypasses BW_SESSION env var)
bw get password "My App Login" --session "$BW_SESSION"
```

## Listing and Searching

```bash
# List all items
bw list items

# Search by name keyword
bw list items --search "github"

# Filter by folder ID
bw list items --folderid "<folder-uuid>"

# Filter by organization
bw list items --organizationid "<org-uuid>"

# Filter by collection
bw list items --collectionid "<collection-uuid>"

# Filter by URL
bw list items --url "https://github.com"

# List folders
bw list folders

# List collections
bw list collections

# List organizations
bw list organizations
```

## Creating Items

```bash
# Generate a JSON template for a login item
bw get template item.login

# Create an item from a JSON file
bw create item item.json

# Encode item JSON to base64 (required by create/edit)
bw create item "$(cat item.json | bw encode)"

# Create a folder
bw create folder "$(echo '{"name":"MyFolder"}' | bw encode)"
```

## Editing and Deleting

```bash
# Edit an existing item (provide full updated JSON)
bw edit item "<uuid>" "$(cat updated-item.json | bw encode)"

# Delete an item (moves to trash)
bw delete item "<uuid>"

# Delete a folder
bw delete folder "<uuid>"

# Empty trash
bw delete item "<uuid>" --permanent
```

## Output Formatting

```bash
# Get item as pretty-printed JSON
bw get item "My App" | python3 -m json.tool

# Extract a field with jq
bw get item "My App" | jq '.login.password'

# Export entire vault as JSON
bw export --format json --output vault-backup.json

# Export as encrypted JSON
bw export --format encrypted_json --output vault-backup-enc.json
```
