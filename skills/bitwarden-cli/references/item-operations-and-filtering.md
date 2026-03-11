# Bitwarden CLI Item Operations and Filtering

## Item Types

| Type | `type` value | Description |
| --- | --- | --- |
| Login | `1` | Username, password, URLs, TOTP |
| Secure Note | `2` | Freeform text note |
| Card | `3` | Credit/debit card details |
| Identity | `4` | Personal identity information |

## JSON Templates

Generate a JSON template before creating items:

```bash
# Login item template
bw get template item.login

# Secure note template
bw get template item.secureNote

# Card template
bw get template item.card

# Field template (for custom fields)
bw get template item.field

# URI template (for login URLs)
bw get template item.uri
```

## Creating Items from Templates

```bash
# Build a login item JSON and create it
ITEM_JSON=$(cat <<'EOF'
{
  "organizationId": null,
  "collectionIds": null,
  "folderId": null,
  "type": 1,
  "name": "My App Login",
  "notes": null,
  "favorite": false,
  "login": {
    "uris": [{"match": null, "uri": "https://app.example.com"}],
    "username": "user@example.com",
    "password": "s3cr3t",
    "totp": null
  }
}
EOF
)

bw create item "$(echo "$ITEM_JSON" | bw encode)"
```

## Filtering List Results

```bash
# Search by keyword (name, username, URL)
bw list items --search "github"

# Filter by folder
bw list items --folderid "$(bw list folders | jq -r '.[] | select(.name=="Work") | .id')"

# Filter by URL
bw list items --url "https://github.com"

# Filter by organization
bw list items --organizationid "<org-uuid>"

# Filter by collection
bw list items --collectionid "<collection-uuid>"

# Combine filters
bw list items --search "api" --organizationid "<org-uuid>"
```

## Extracting Fields with jq

```bash
# Get password from a search result
bw list items --search "My App" | jq -r '.[0].login.password'

# List all item names
bw list items | jq -r '.[].name'

# Get username and password pairs
bw list items | jq -r '.[] | "\(.name): \(.login.username)"'

# Find items by URL
bw list items | jq -r '.[] | select(.login.uris[]?.uri | test("github.com")) | .name'
```

## Bulk Export

```bash
# Export vault as JSON (unencrypted)
bw export --format json --output vault.json

# Export vault as encrypted JSON (Bitwarden-encrypted, portable)
bw export --format encrypted_json --output vault-enc.json

# Export a specific organization's vault
bw export --organizationid "<org-uuid>" --format json --output org-vault.json
```

## Trash and Restore

```bash
# Delete an item (soft delete — moves to trash)
bw delete item "<uuid>"

# Restore an item from trash
bw restore item "<uuid>"

# Permanently delete (bypass recovery window)
bw delete item "<uuid>" --permanent
```

## Organization Collections

```bash
# List collections in an organization
bw list collections --organizationid "<org-uuid>"

# Assign an item to a collection when creating
# Set "collectionIds": ["<collection-uuid>"] in the item JSON

# List items in a specific collection
bw list items --collectionid "<collection-uuid>"
```

## Encoding Item JSON

The `bw create` and `bw edit` commands require base64-encoded JSON:

```bash
# Encode JSON for use with bw create/edit
echo '{"name":"test"}' | bw encode

# Decode to verify
echo "<base64-string>" | base64 --decode
```

For full item schema and advanced filtering, see: <https://bitwarden.com/help/cli/>
