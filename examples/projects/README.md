# project Resources

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [tfe_project.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_import_projects"></a> [import\_projects](#input\_import\_projects) | (Optional ["true", "data", "false"]) Enable projects imports, import data output, and initial API data capture. | `string` | `"false"` | no |
| <a name="input_projects_import_map"></a> [projects\_import\_map](#input\_projects\_import\_map) | (Optional Map) This map of Strings is intended to be populated by capturing the output of `terraform output projects_import_map` {'name' = 'prj-*'} | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_projects_import_map"></a> [projects\_import\_map](#output\_projects\_import\_map) | Output intended to be used for `var.projects_import_map` input |
| <a name="output_terracurl_data_projects_response"></a> [terracurl\_data\_projects\_response](#output\_terracurl\_data\_projects\_response) | The output from terracurl json response to the `projects` api endpoint |
<!-- END_TF_DOCS -->

### Usage

To provide data and resources to import and take control of projects in HCP Terraform or Terraform Enterprise utilizing the [projects API](https://developer.hashicorp.com/terraform/cloud-docs/api-docs/projects)

**_NOTE:_** The organization token and the owners team token can act as an owner on these endpoints.

Populate the `*.tfvars` file as needed and illustrated below;


```shell
export TF_TOKEN = < Organization or Owners Team token >
export VAR_TF_tfc_org_token = < Organization or Owners Team token >

cat <<EOF >> projects.auto.tfvars
# one of ["true", "data", "false"]
import_projects    = "false"
projects_import_map = {}
tfc_org         = "example_org"
tfc_org_token   = $TF_TOKEN || $VAR_TF_tfc_org_token
EOF

```

#### import_projects = false

When `var.import_projects == false` only the produce empty outputs, this allows you to review what you will be imported and plan for changes, or use terraform output command to utilise the data.

```shell
terraform-tfe-import_organization % terraform apply -var import_projects="false"...
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

projects_import_list = []
projects_import_map = {}
```

#### import_projects = data

When `var.import_projects == data` all outputs will be populated, this allows you to review what you will imported and plan for changes.
The main use case is capturing the output of the various outputs to construct the `var.import_map`

```shell
terraform-tfe-import_organization % terraform apply -var import_projects="data"...
...
data.terracurl_request.projects["data"]: Reading...
data.tfe_projects.this["data"]: Reading...
data.terracurl_request.projects["data"]: Read complete after 1s [id=projects]
data.tfe_projects.this["data"]: Read complete after 0s [id=${var.tfc-org}]

Changes to Outputs:
  + projects                         = {
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

projects = {
...
projects_import_list = tolist([
...
projects_import_map = tomap({
...
terracurl_data_projects_response = {
  "data" = [

```

#### import_projects = true

When `var.import_projects == true` then the available resources will be imported to state and managed **ONLY** if  `var.projects_import_map` is populated. The intention is to populate this value from the outputs see [README.md](../../README.md) for docs.

**_NOTE:_** Stepping `var.import_projects` back to `data` or `false` is a destructive action once this change has been made.

``` shell
terraform output projects_import_map | sed -e 's/tomap(/projects_import_map = /g' | sed -e 's/)//g' >> example.auto.tfvars.example
```

Once you have the projects resources imported if you wish to manage them further and update the resource it is advised you use a [move block](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring#moved-block-syntax) to take further control of the resource and remove it from the `var.project_import_map` afterwards.
