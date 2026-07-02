# AGENTS.md

## Project Overview

This is a **root-module-only** Terraform configuration for importing an existing HCP Terraform or Terraform Enterprise (TFE) organization — its teams, projects, and workspaces — into Terraform state management.

Key technologies:
- Terraform `~> 1.8`
- Provider `hashicorp/tfe` `~> 0.57.0`
- Provider `devops-rob/terracurl` `1.2.1`

> **Important**: This cannot be used as a child module. Terraform `import` blocks are only valid in root declarations and will error if nested inside a module.

---

## Setup

### Prerequisites

- Terraform `~> 1.8` installed
- [`tflint`](https://github.com/terraform-linters/tflint) for linting
- [`terraform-docs`](https://terraform-docs.io/) for README generation
- `jq` recommended for working with JSON API responses

### Authentication

```sh
export TFE_TOKEN="<your token from TFE/HCP Terraform>"
export TF_VAR_tfc_org_token=$TFE_TOKEN
```

Alternatively, use `terraform login` (`make login`).

### Variables setup

Copy the example tfvars and populate it:

```sh
cp variables.auto.tfvars.example terraform.auto.tfvars
# then edit terraform.auto.tfvars
```

Minimum required values:

```hcl
tfc_org       = "<your-org-name>"
tfc_org_token = "<org-or-owners-team-token>"
tfe_hostname  = "app.terraform.io"  # change for TFE self-hosted
```

### Initialize

```sh
make init
# or: terraform init
```

---

## Development Workflow

### Make targets

```sh
make help       # list all available targets
make init       # terraform init
make plan       # terraform plan
make apply      # terraform init + plan + apply
make destroy    # terraform apply -destroy
make fmt        # terraform fmt && tflint
make docs       # regenerate README.md with terraform-docs
```

### Targeted plan (single variable)

```sh
terraform plan -var import_workspaces="data"
terraform plan -var import_teams="data"
terraform plan -var import_projects="data"
terraform plan -var import_organization="data"
```

### Override pattern

To customise a resource file without modifying it directly:

```sh
make terraform-override file=workspaces.tf
# produces workspaces_override.tf — edit that instead
```

---

## Core Pattern: Three-Phase Import Lifecycle

Every resource collection uses a string-enum variable (`"false"` / `"data"` / `"true"`) to control a three-phase workflow:

| Phase | Variable value | What happens |
|---|---|---|
| 1 | `"false"` | Nothing active; outputs are empty |
| 2 | `"data"` | Data sources and terracurl API calls run; outputs populated for inspection |
| 3 | `"true"` | `import` blocks and resources become active; requires the `*_import_map` var to be populated |

**Sequence for importing workspaces (example):**

```sh
# Phase 2: discover workspace IDs
terraform apply -var import_workspaces="data"
terraform output workspaces_import_map

# Capture output into tfvars
terraform output workspaces_import_map \
  | sed -e 's/tomap(/workspaces_import_map = /g' | sed -e 's/)//g' \
  >> terraform.auto.tfvars

# Phase 3: import into state
terraform apply -var import_workspaces="true"
```

> **Warning**: Stepping a variable back from `"true"` to `"data"` or `"false"` after importing resources is a **destructive** action.

---

## File Structure

Each resource collection is self-contained in a single `.tf` file. All of the following live together in one file per collection:

- `data` sources (tfe provider + terracurl API call)
- `locals` (jsondecode of API response)
- `output` blocks
- `import` block (immediately before the matching resource)
- `resource` block

Resource files: `organization.tf`, `teams.tf`, `projects.tf`, `workspaces.tf`

Scaffolding files (empty by default, extend here): `main.tf`, `outputs.tf`, `backend.tf`

---

## Code Style and Conventions

### `for_each` guard pattern

All conditional blocks use `for_each` with the sentinel key `"data"`. Never use `count` for these patterns.

```hcl
for_each = contains(["data", "true"], var.import_workspaces) ? { "data" = "true" } : {}
```

### Import block placement

The `import` block must always immediately precede its matching `resource` block, with identical `for_each` expressions.

### Variable naming

- `import_<resource>` — string enum `"true"/"data"/"false"`
- `<resource>_import_map` — `map(any)` fed into import/resource `for_each`
- Output for map input: `<resource>_import_map`
- Output for raw API data: `terracurl_data_<resource>_response`

### Variable descriptions format

```hcl
description = "(Optional [\"true\", \"data\", \"false\"]) What this controls"
description = "(Optional Map) Description with example {'name' = 'id'}"
description = "(Required Sensitive) Description `export TF_VAR_name=value`"
```

### Section separators in `variables.tf`

```hcl
#------------------------------------------------------------------------------
# <Resource Collection>
#------------------------------------------------------------------------------
```

### API pagination

Terracurl requests use TFE default pagination (20 items). To support more than 20 items, create an `*_override.tf` file — do not modify the original resource files.

---

## Linting and Formatting

```sh
make fmt
# equivalent to:
terraform fmt
tflint
```

Run `terraform fmt` before committing any `.tf` changes.

---

## README Generation

The `README.md` is **auto-generated** between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers. Do not manually edit that section.

```sh
make docs
# equivalent to:
terraform-docs markdown table --output-file README.md .
```

---

## Security Notes

- `tfc_org_token` is marked `sensitive = true` in variables — never log or output it
- Pass credentials via environment variables (`TFE_TOKEN`, `TF_VAR_tfc_org_token`), not in `.tfvars` files committed to source control
- `.gitignore` should exclude `*.tfvars` files containing real credentials
- terracurl headers always use `Authorization = "Bearer ${var.tfc_org_token}"`

---

## Troubleshooting

- **"import block detected in module"** — this codebase must be run as a root module, not called as a child module
- **Pagination missing resources** — default API page size is 20; use `*_override.tf` to add `?page[size]=100` query param
- **Stepping back from `true`** — re-importing after removing resources from state requires starting from phase `"data"` again
- **Token alias helper**:
  ```sh
  alias tf-token-helper="export TFE_TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials."app.terraform.io".token')"
  ```
