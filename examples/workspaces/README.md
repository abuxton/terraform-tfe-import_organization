# Workspace Resources

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [tfe_workspace.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_import_workspaces"></a> [import\_workspaces](#input\_import\_workspaces) | (Optional ["true", "data", "false"]) Enable workspace imports, import data output, and initial API data capture. | `string` | `"false"` | no |
| <a name="input_workspaces_import_map"></a> [workspaces\_import\_map](#input\_workspaces\_import\_map) | (Optional Map) This map of Strings is intended to be populated by capturing the output of `terraform output workspaces_import_map` {'name' = 'ws-*'} | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspaces_import_map"></a> [workspaces\_import\_map](#output\_workspaces\_import\_map) | Output intended to be used for `var.workspaces_import_map` input |
| <a name="output_terracurl_data_workspaces_response"></a> [terracurl\_data\_workspaces\_response](#output\_terracurl\_data\_workspaces\_response) | The output from terracurl json response to the `workspaces` api endpoint |
<!-- END_TF_DOCS -->

### Usage

To provide data and resources to import and take control of workspaces in HCP Terraform or Terraform Enterprise utilizing the [workspaces API](https://developer.hashicorp.com/terraform/cloud-docs/api-docs/workspaces)

**_NOTE:_** The organization token and the owners team token can act as an owner on these endpoints.

Populate the `*.tfvars` file as needed and illustrated below;


```shell
export TF_TOKEN = < Organization or Owners Team token >
export VAR_TF_tfc_org_token = < Organization or Owners Team token >

cat <<EOF >> workspaces.auto.tfvars
# one of ["true", "data", "false"]
import_workspaces    = "false"
workspaces_import_map = {}
tfc_org         = "example_org"
tfc_org_token   = $TF_TOKEN || $VAR_TF_tfc_org_token
EOF

```

#### import_workspaces = false

When `var.import_workspaces == false` only produce empty outputs, this allows you to review what will be imported and plan for changes, or use terraform output command to utilise the data.

```shell
terraform-tfe-import_organization % terraform apply -var import_workspaces="false"...
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

workspaces_import_map = {}
```

#### import_workspaces = data

When `var.import_workspaces == data` all outputs will be populated, this allows you to review what will be imported and plan for changes.
The main use case is capturing the output of the various outputs to construct the `var.import_map`.

The `tfe_workspace_ids` data source retrieves all workspaces using `names = ["*"]` and provides them as a map of `{workspace_name => workspace_id}`. The terracurl response provides the raw API payload.

```shell
terraform-tfe-import_organization % terraform apply -var import_workspaces="data"...
...
data.terracurl_request.workspaces["data"]: Reading...
data.tfe_workspace_ids.this["data"]: Reading...
data.terracurl_request.workspaces["data"]: Read complete after 1s [id=workspaces]
data.tfe_workspace_ids.this["data"]: Read complete after 0s [id=${var.tfc_org}]

Changes to Outputs:
  + workspaces_import_map = {
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

workspaces_import_map = tomap({
  "my-workspace" = "ws-xxxxxxxxxxxx"
  ...
})
terracurl_data_workspaces_response = {
  "data" = [

```

#### import_workspaces = true

When `var.import_workspaces == true` then the available resources will be imported to state and managed **ONLY** if `var.workspaces_import_map` is populated. The intention is to populate this value from the outputs see [README.md](../../README.md) for docs.

**_NOTE:_** Stepping `var.import_workspaces` back to `data` or `false` is a destructive action once this change has been made.

``` shell
terraform output workspaces_import_map | sed -e 's/tomap(/workspaces_import_map = /g' | sed -e 's/)//g' >> example.auto.tfvars.example
```

Once you have the workspace resources imported if you wish to manage them further and update the resource it is advised you use a [move block](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring#moved-block-syntax) to take further control of the resource and remove it from the `var.workspaces_import_map` afterwards.
