# Team resources



## Usage

<https://developer.hashicorp.com/terraform/cloud-docs/api-docs/teams>
**_NOTE:_** The organization token and the owners team token can act as an owner on these endpoints.

Populate the `*.tfvars` file as needed and illustrated below;


```shell
export TF_TOKEN = < Organization or Owners Team token >
export VAR_TF_tfc_org_token = < Organization or Owners Team token >

cat <<EOF >> teams.auto.tfvars
# one of ["true", "data", "false"]
import_teams    = "false"
tfc_org         = "example_org"
tfc_org_token   = $TF_TOKEN || $VAR_TF_tfc_org_token
EOF
```

### import_teams = false

When `var.import_teams == false` only the outputs `teams` and `terracurl_data_teams_responce` will be populated, this allows you to review what you will be imported and plan for changes, or use terraform output command to utilise the data.

### import_teams = data

When `var.import_teams == data` only all outputs will be populated, this allows you to review what you will imported and plan for changes.

### import_teams = true

When `var.import_teams == true` then the available resources will be imported to state.
**_NOTE:_** Stepping `var.import_teams` back to `data` or `false` is a destructive action once this change has been made.
