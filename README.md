# TFE import Organization

This module is a set of code to help you take control of a manual created HCP Terraform or Terraform Enterprise organization.

![XKCD a flipant answer to most things!](https://imgs.xkcd.com/comics/fixing_problems.png  "XKCD the answer to most things! ")
[https://xkcd.com/1739/](https://xkcd.com/1739/)

## Usage

Due to nature of Infrastructure of Code, terraform as a declarative language and this modules focus on the import capabilities of the Terraform Cli and language block usage is beyond scope of the README. The `<./examples>` folder talks through utilizing this module.

**_NOTE:_** Import Blocks are *ONLY* allowed in route declarations or you will encounter the following if you try use this codebase as a module;

```json
 Error: An import block was detected in "module.example". Import blocks are only allowed in the
```

**_NOTE:_** Setting a `$TFE_TOKEN` environment variable is the recommended approach for the TFE provider auth. You may find the below helpful

```shell
export TFE_TOKEN="<your token from TFE service>"
alias tf-token-helper="export TFE_TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials."app.terraform.io".token' )"
export TF_VAR_tfc_org_token=$TFE_TOKEN
```

**_NOTE:_**  Pagination of curl and the Terraform APIs only support upto 100 paged entries, This code only supports the default 20. If you require more than that either update the code with a `*_override.tf` file or you'll have to use curl and extract the data more directly to feed back into the code <https://developer.hashicorp.com/terraform/cloud-docs/api-docs#pagination>

**_NOTE:_** You may want `jq` or equivalent tool to work with `json` .


### Credits

* <https://github.com/alexbasista/terraform-tfe-workspacer>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.8 |
| <a name="requirement_terracurl"></a> [terracurl](#requirement\_terracurl) | 1.2.1 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.55.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terracurl"></a> [terracurl](#provider\_terracurl) | 1.2.1 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_team.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team) | resource |
| [terracurl_request.teams](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/data-sources/request) | data source |
| [tfe_teams.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/teams) | data source |

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
