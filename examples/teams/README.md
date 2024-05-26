# Team resources


## Usage

Populate the `*.tfvars` file as needed and illustrated below;



```shell
export TF_TOKEN = <user or org token>
export VAR_TF_tfc_org_token

cat <<EOF >> teams.auto.tfvars
import_teams    = "false"
tfc_org         = "example_org"
tfc_org_token   = $TF_TOKEN || $VAR_TF_tfc_org_token
EOF



```
