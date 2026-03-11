# 1Password CLI Command Cookbook

## Account and Sign-In

```bash
# Sign in interactively
op signin

# Sign in to a specific account
op signin --account my.1password.com

# List signed-in accounts
op account list

# Add a new account
op account add

# Sign out of current account
op signout

# Remove an account from the CLI
op account forget my.1password.com
```

## Vaults

```bash
# List all accessible vaults
op vault list

# Get details of a vault
op vault get "Private"

# List vaults in JSON
op vault list --format json
```

## Items

```bash
# List all items in a vault
op item list --vault "Private"

# List all items across all vaults
op item list

# Get an item by name
op item get "My App Login" --vault "Private"

# Get an item in JSON format
op item get "My App Login" --format json

# Get a specific field value
op item get "My App Login" --fields password

# Get multiple fields
op item get "My App Login" --fields username,password

# Get an item by UUID
op item get "<uuid>"
```

## Reading Secret Values

```bash
# Read a specific field by secret reference
op read "op://Private/My App Login/password"

# Read username
op read "op://Private/My App Login/username"

# Read a custom field
op read "op://Private/My App Login/api_key"

# Read a document attachment
op document get "My Certificate" --vault "Shared" --output cert.pem
```

## Creating and Editing Items

```bash
# Create a login item
op item create \
  --category login \
  --title "My New App" \
  --vault "Private" \
  --url "https://app.example.com" \
  username="user@example.com" \
  password="s3cr3t"

# Create with a generated password
op item create \
  --category login \
  --title "Auto Password App" \
  --generate-password

# Edit an item field
op item edit "My App Login" password="newpassword"

# Add a custom field
op item edit "My App Login" "api_key[password]=abc123"

# Delete an item (moves to trash)
op item delete "My App Login" --vault "Private"

# Archive an item
op item delete "My App Login" --archive
```

## Injecting Secrets with op run

```bash
# Run a command with secrets injected as env vars
# The command reads OP_* env vars that contain op:// references
OP_DB_PASSWORD="op://Private/My App/db_password" \
  op run -- node server.js

# Use an .env file with op:// references
# .env.tpl:
#   DB_PASSWORD=op://Private/MyApp/password
#   API_KEY=op://Shared/APIKeys/key
op run --env-file .env.tpl -- python app.py
```

## Injecting Secrets with op inject

```bash
# Inject secrets into a template file
# template.conf:
#   password = {{ op://Private/MyApp/password }}
op inject -i template.conf -o config.conf

# Inject and pipe to a command
op inject -i .env.tpl | source /dev/stdin
```

## Output Formatting

```bash
# JSON output
op item get "My App" --format json

# CSV output
op item list --format csv

# Table output (default)
op item list

# Parse JSON with jq
op item get "My App" --format json | jq '.fields[] | select(.label=="password") | .value'
```
