# Team resources


## Usage

<https://developer.hashicorp.com/terraform/cloud-docs/api-docs/teams>
**_NOTE:_** The organization token and the owners team token can act as an owner on these endpoints.

Populate the `*.tfvars` file as needed and illustrated below;


```shell
export TF_TOKEN = < Organization or Owners Team token >
export VAR_TF_tfc_org_token = < Organization or Owners Team token >

cat <<EOF >> teams.auto.tfvars
import_teams    = "false"
tfc_org         = "example_org"
tfc_org_token   = $TF_TOKEN || $VAR_TF_tfc_org_token
EOF



```
