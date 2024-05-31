# Team Resources

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [tfe_team.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_import_teams"></a> [import\_teams](#input\_import\_teams) | (Optional ["true", "data", "false"]) Enable team imports, import data output, and initial API data capture | `string` | `"false"` | no |
| <a name="input_teams_import_map"></a> [teams\_import\_map](#input\_teams\_import\_map) | (Optional Map) This map of Strings is intended to be populated by capturing the output of `terarform output teams_import_map` | `map(any)` | `{}` | no |
| <a name="input_tfc_org"></a> [tfc\_org](#input\_tfc\_org) | (Required) Name of the HCP terraform or Terraform enterprise organization | `string` | n/a | yes |
| <a name="input_tfc_org_token"></a> [tfc\_org\_token](#input\_tfc\_org\_token) | (Required Sensitive) Your TFC Org or Owners team level token, or token with sufficient permissions `export TF_VAR_tfc_org_token=TF_TOKEN` | `string` | n/a | yes |
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | (Optional sting) Terraform Enterprise server hostname defaults to HCP terraforms hostname `app.terraform.io` | `string` | `"app.terraform.io"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_teams"></a> [teams](#output\_teams) | Output for teams data\_source |
| <a name="output_teams_import_map"></a> [teams\_import\_map](#output\_teams\_import\_map) | Output intended to be used for `var.teams_import_map` input |
| <a name="output_terracurl_data_teams_response"></a> [terracurl\_data\_teams\_response](#output\_terracurl\_data\_teams\_response) | The output from terracurl json response to the `teams` api endpoint |
<!-- END_TF_DOCS -->

### Usage

To provide data and resources to import and take control of teams in HCP Terraform or Terraform Enterprise utilizing the [teams API](https://developer.hashicorp.com/terraform/cloud-docs/api-docs/teams)

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

#### import_teams = false

When `var.import_teams == false` only the produce empty outputs, this allows you to review what you will be imported and plan for changes, or use terraform output command to utilise the data.

```shell
terraform-tfe-import_organization % terraform apply -var import_teams="false"...
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

teams_import_list = []
teams_import_map = {}
```

#### import_teams = data

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

#### import_teams = true

When `var.import_teams == true` then the available resources will be imported to state and managed **ONLY** if  `var.teams_import_map` is populated. The intention is to populate this value from the outputs see [README.md](../../README.md) for docs.

**_NOTE:_** Stepping `var.import_teams` back to `data` or `false` is a destructive action once this change has been made.

``` shell
terraform output teams_import_map | sed -e 's/tomap(/teams_import_map = /g' | sed -e 's/)//g' >> example.auto.tfvars.example
```

Once you have the teams resources imported if you wish to manage them further and update the resource it is advised you use a [move block](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring#moved-block-syntax) to take further control of the resource and remove it from the `var.team_import_map` afterwards.
