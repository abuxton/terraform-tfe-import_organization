# Team Resources


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
teams_import_map = {}
tfc_org         = "example_org"
tfc_org_token   = $TF_TOKEN || $VAR_TF_tfc_org_token
EOF

```

### import_teams = false

When `var.import_teams == false` only the produce empty outputs, this allows you to review what you will be imported and plan for changes, or use terraform output command to utilise the data.

```shell
terraform-tfe-import_organization % terraform apply -var import_teams="false"...
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

teams_import_list = []
teams_import_map = {}
```

### import_teams = data

When `var.import_teams == data` all outputs will be populated, this allows you to review what you will imported and plan for changes.
The main use case is capturing the output of the various outputs to construct the `var.import_map`

```shell
terraform-tfe-import_organization % terraform apply -var import_teams="data"...
...
data.terracurl_request.teams["data"]: Reading...
data.tfe_teams.this["data"]: Reading...
data.terracurl_request.teams["data"]: Read complete after 1s [id=teams]
data.tfe_teams.this["data"]: Read complete after 0s [id=${var.tfc-org}]

Changes to Outputs:
  + teams                         = {
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

teams = {
...
teams_import_list = tolist([
...
teams_import_map = tomap({
...
terracurl_data_teams_response = {
  "data" = [

```

### import_teams = true

When `var.import_teams == true` then the available resources will be imported to state and managed **ONLY** if  `var.teams_import_map` is populated. The intention is to populate this value from the outputs see [README.md](../../README.md) for docs.

**_NOTE:_** Stepping `var.import_teams` back to `data` or `false` is a destructive action once this change has been made.

``` shell
terraform output teams_import_map | sed -e 's/tomap(/teams_import_map = /g' | sed -e 's/)//g' >> example.auto.tfvars.example
```

