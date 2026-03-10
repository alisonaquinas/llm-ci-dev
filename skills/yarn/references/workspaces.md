# Yarn Workspaces

## Enabling Workspaces

Declare a `workspaces` field in the root `package.json`:

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

Running `yarn install` at the root installs all workspace dependencies and links sibling packages.

## Directory Layout

```
my-monorepo/
├── package.json          ← root (workspaces declared here)
├── yarn.lock             ← single lock file for the entire repo
├── .yarn/
├── packages/
│   └── my-lib/
│       └── package.json
└── apps/
    └── my-app/
        └── package.json
```

## workspace: Protocol

Reference a sibling workspace as a dependency using the `workspace:` protocol:

```json
{
  "name": "my-app",
  "dependencies": {
    "my-lib": "workspace:*"
  }
}
```

| Specifier | Resolved to on publish |
| --- | --- |
| `workspace:*` | Exact current version |
| `workspace:^` | `^<version>` range |
| `workspace:~` | `~<version>` range |

Yarn substitutes the real version when packing or publishing.

## Running Commands Across Workspaces

### yarn workspaces foreach (Berry)

```bash
# Run build in every workspace (sequential)
yarn workspaces foreach run build

# Run in parallel
yarn workspaces foreach --parallel run build

# Skip the root workspace
yarn workspaces foreach --no-private run test

# Target only specific workspaces
yarn workspaces foreach --include 'packages/*' run lint
```

### Targeting a Single Workspace

```bash
# Run a script in one workspace
yarn workspace my-lib run build

# Add a dependency to one workspace
yarn workspace my-app add axios
```

## Focus Installs

Install only the dependencies needed for a specific workspace (useful in large monorepos):

```bash
# Install my-app and its transitive workspace deps only
yarn workspaces focus my-app
```

## Constraints

Constraints enforce rules across all workspace `package.json` files using a Prolog-like DSL in `constraints.pro`:

```prolog
% All workspaces must use the same version of typescript
gen_enforced_dependency(WorkspaceCwd, 'typescript', '^5.0.0', devDependencies) :-
  workspace_has_dependency(WorkspaceCwd, 'typescript', _, devDependencies).
```

Run constraints:

```bash
yarn constraints
yarn constraints --fix
```

## Tips

- Keep `"private": true` on the root to prevent accidental root package publishing.
- The `workspace:` protocol guarantees local resolution and prevents accidentally pulling a stale version from the registry.
- With PnP mode, phantom dependency issues surface early — each workspace must declare all its direct dependencies explicitly.
- Use `yarn workspaces list --json` to enumerate workspace names and paths in scripts.
