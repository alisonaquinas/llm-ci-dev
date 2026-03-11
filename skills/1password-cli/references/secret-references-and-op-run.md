# 1Password Secret References and op run

## Secret Reference Syntax

Secret references use the `op://` URI scheme to point to a specific field in a 1Password item:

```
op://<vault>/<item>/<field>
```

Examples:

```
op://Private/My App Login/password
op://Shared/Production DB/username
op://DevOps/AWS Prod/access_key_id
op://Private/My App Login/Section Name/custom_field
```

- **vault** — vault name or UUID
- **item** — item name or UUID
- **field** — field label (case-insensitive); use the field label as shown in the 1Password UI

## Reading a Secret Reference

```bash
# Resolve a reference directly
op read "op://Private/My App/password"

# Read to a variable (avoid logging)
DB_PASS=$(op read "op://Private/MyApp/db_password")
```

## op run — Inject Secrets into Commands

`op run` resolves `op://` references found in environment variables before passing them to the command:

```bash
# Inline env var with op:// reference
OP_DB_PASSWORD="op://Private/MyApp/db_password" \
  op run -- ./start-server.sh

# Multiple secrets
DB_PASSWORD="op://Private/MyApp/db_password" \
DB_USER="op://Private/MyApp/db_username" \
  op run -- node app.js
```

## .env File with op run

Create a `.env` file (or `.env.tpl`) containing `op://` references:

```bash
# .env.tpl
DB_PASSWORD=op://Private/MyApp/db_password
API_KEY=op://Shared/APIKeys/production
AWS_ACCESS_KEY_ID=op://DevOps/AWS Prod/access_key_id
AWS_SECRET_ACCESS_KEY=op://DevOps/AWS Prod/secret_access_key
```

```bash
# Load and run — secrets are resolved and exported for the command only
op run --env-file .env.tpl -- python manage.py migrate
```

## op inject — File Templating

`op inject` processes template files with `{{ op://... }}` placeholders:

```bash
# template.yaml
# database:
#   password: {{ op://Private/MyApp/db_password }}
#   user: {{ op://Private/MyApp/db_user }}

op inject -i template.yaml -o config.yaml
```

## CI/CD Integration

### GitHub Actions

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: 1password/load-secrets-action@v2
        with:
          export-env: true
        env:
          OP_SERVICE_ACCOUNT_TOKEN: ${{ secrets.OP_SERVICE_ACCOUNT_TOKEN }}
          DB_PASSWORD: op://Private/MyApp/db_password
      - run: ./deploy.sh
```

### GitLab CI

```yaml
deploy:
  script:
    - export OP_SERVICE_ACCOUNT_TOKEN="$OP_SERVICE_ACCOUNT_TOKEN"
    - DB_PASSWORD="op://Private/MyApp/db_password" op run -- ./deploy.sh
```

### Generic Pipeline

```bash
# In any CI pipeline step
export OP_SERVICE_ACCOUNT_TOKEN="$OP_SERVICE_ACCOUNT_TOKEN"
op run --env-file .env.prod.tpl -- ./deploy.sh
```

## Connect Server References

When using a 1Password Connect server, references use the same `op://` scheme but resolve through the Connect API:

```bash
export OP_CONNECT_HOST="https://connect.example.com"
export OP_CONNECT_TOKEN="<connect-token>"

op read "op://vault-uuid/item-uuid/field"
```

For advanced patterns, see: <https://developer.1password.com/docs/cli/reference/>
