# npm Workspaces

## Enabling Workspaces

Define a `workspaces` field in the root `package.json`:

```json
{
  "name": "my-monorepo",
  "private": true,
  "workspaces": [
    "packages/*",
    "apps/*"
  ]
}
```

Running `npm install` at the root installs all workspace dependencies and creates symlinks in `node_modules` for each workspace package.

## Directory Layout

```text
my-monorepo/
├── package.json          ← root (workspaces declared here)
├── package-lock.json     ← single lock file for the entire repo
├── node_modules/
│   └── my-lib -> ../packages/my-lib   (symlink)
├── packages/
│   └── my-lib/
│       └── package.json
└── apps/
    └── my-app/
        └── package.json
```

## Running Commands in Workspaces

```bash
# Run a script in a specific workspace
npm run build --workspace=packages/my-lib
npm run build -w packages/my-lib

# Run a script in all workspaces
npm run test --workspaces
npm run test -ws

# Run only in workspaces that have the script defined
npm run test --workspaces --if-present
```

## Installing Dependencies

```bash
# Add a dependency to a specific workspace
npm install lodash --workspace=apps/my-app

# Add a dev dependency to all workspaces
npm install --save-dev jest --workspaces
```

## Cross-Workspace Dependencies

Reference a sibling workspace by name in `package.json`:

```json
{
  "name": "my-app",
  "dependencies": {
    "my-lib": "*"
  }
}
```

npm resolves `my-lib` to the local workspace package via a symlink rather than fetching from the registry.

## Hoisting Behaviour

By default, npm hoists shared dependencies to the root `node_modules`. This reduces duplication but means:

- A package not declared as a direct dependency may still be importable (phantom dependencies).
- Packages with incompatible peer dependency versions may each get a private copy.

## List Workspaces

```bash
npm exec --workspaces -- node -e "console.log(process.env.npm_package_name)"
```

Or inspect the workspace metadata:

```bash
npm query .workspace
```

## Tips

- Keep `"private": true` on the root to prevent accidental root package publishing.
- Use consistent naming (`@scope/package-name`) for workspace packages to avoid collisions with registry packages.
- Run `npm ci` at the root in CI — it installs all workspaces in one pass.
