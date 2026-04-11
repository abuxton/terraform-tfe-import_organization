# Organization Resource

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/organization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_import_organization"></a> [import\_organization](#input\_import\_organization) | (Optional ["true", "data", "false"]) Enable organization import, import data output, and initial API data capture | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_organization"></a> [organization](#output\_organization) | Output for organization data source |
| <a name="output_terracurl_data_organization_response"></a> [terracurl\_data\_organization\_response](#output\_terracurl\_data\_organization\_response) | The output from terracurl json response to the `organization` api endpoint |
<!-- END_TF_DOCS -->

### Usage

To provide data and resources to import and take control of an organization in HCP Terraform or Terraform Enterprise utilizing the [organizations API](https://developer.hashicorp.com/terraform/cloud-docs/api-docs/organizations)

**_NOTE:_** The organization token and the owners team token can act as an owner on these endpoints.

**_NOTE:_** The organization is a single resource identified by `var.tfc_org`. No import map is required — the import ID is simply the organization name.

Populate the `*.tfvars` file as needed and illustrated below;


```shell
export TF_TOKEN = < Organization or Owners Team token >
export VAR_TF_tfc_org_token = < Organization or Owners Team token >

cat <<EOF >> organization.auto.tfvars
# one of ["true", "data", "false"]
import_organization = "false"
tfc_org             = "example_org"
tfc_org_token       = $TF_TOKEN || $VAR_TF_tfc_org_token
EOF

```

#### import_organization = false

When `var.import_organization == false` only produce empty outputs, this allows you to review what will be imported and plan for changes.

```shell
terraform-tfe-import_organization % terraform apply -var import_organization="false"...
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

organization = null
```

#### import_organization = data

When `var.import_organization == data` all outputs will be populated, this allows you to review the organization details before importing.
The `tfe_organization` data source retrieves the organization's current configuration. The terracurl response provides the raw API payload.

```shell
terraform-tfe-import_organization % terraform apply -var import_organization="data"...
...
data.tfe_organization.this["data"]: Reading...
data.terracurl_request.organization["data"]: Reading...
data.tfe_organization.this["data"]: Read complete after 0s [id=example_org]
data.terracurl_request.organization["data"]: Read complete after 1s [id=organization]

Changes to Outputs:
  + organization = {
      "data" = {
        "email"                = "admin@example.com"
        "external_id"         = "org-xxxxxxxxxxxx"
        ...
      }
    }

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

organization = {
  "data" = {
    ...
  }
}
terracurl_data_organization_response = {
  "data" = {

```

#### import_organization = true

When `var.import_organization == true` then the organization will be imported to state and managed. The `email` attribute is automatically retrieved from the `tfe_organization` data source.

**_NOTE:_** No import map is required — the organization is uniquely identified by `var.tfc_org`.

**_NOTE:_** Stepping `var.import_organization` back to `data` or `false` is a destructive action once this change has been made.

```shell
terraform-tfe-import_organization % terraform apply -var import_organization="true"...
...
data.tfe_organization.this["data"]: Reading...
data.tfe_organization.this["data"]: Read complete after 0s [id=example_org]

Terraform will perform the following actions:

  # tfe_organization.this["example_org"] will be imported
    resource "tfe_organization" "this" {
      email = "admin@example.com"
      name  = "example_org"
      ...
    }

Plan: 1 to import, 0 to add, 0 to change, 0 to destroy.

Apply complete! Resources: 1 imported, 0 added, 0 changed, 0 destroyed.
```

Once you have the organization resource imported if you wish to manage it further and update the resource it is advised you use a [move block](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring#moved-block-syntax) to take further control of the resource and remove it from the `for_each` map afterwards.
