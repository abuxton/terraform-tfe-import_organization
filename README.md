# TFE import Organization

This module is a set of code to help you take control of a manual created HCP Terraform or Terraform Enterprise organization.

## Usage

Due to nature of Infrastructure of Code, terraform as a declarative language and this modules focus on the Import capabilities of the Terraform Cli and language block usage is beyond scope of the README. The `./examples` folder talks through utilizing this module.

**_NOTE:_** Setting a `$TFE_TOKEN` environment variable is the recommended approach for the TFE provider auth. You may find the below helpful

```shell

alias tf-token-helper="export TFE_TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials."app.terraform.io".token' )"

```

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
| [terracurl_request.test](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/data-sources/request) | data source |
| [tfe_teams.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/teams) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_team_access"></a> [custom\_team\_access](#input\_custom\_team\_access) | Map of existing Team(s) and custom permissions to grant on Workspace. If used, all keys in the object must be specified. | <pre>map(<br>    object(<br>      {<br>        runs              = string<br>        variables         = string<br>        state_versions    = string<br>        sentinel_mocks    = string<br>        workspace_locking = bool<br>        run_tasks         = bool<br>      }<br>    )<br>  )</pre> | `{}` | no |
| <a name="input_import_teams"></a> [import\_teams](#input\_import\_teams) | (optional bool) Enable team imports, outputs and data | `string` | `"false"` | no |
| <a name="input_team_access"></a> [team\_access](#input\_team\_access) | Map of existing Team(s) and built-in permissions to grant on Workspace. | `map(string)` | `{}` | no |
| <a name="input_tfc_org"></a> [tfc\_org](#input\_tfc\_org) | name of the HCP terraform or Terraform enterprise organization | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_teams"></a> [teams](#output\_teams) | n/a |
| <a name="output_teams_import_list"></a> [teams\_import\_list](#output\_teams\_import\_list) | n/a |
| <a name="output_teams_import_map"></a> [teams\_import\_map](#output\_teams\_import\_map) | n/a |
<!-- END_TF_DOCS -->
