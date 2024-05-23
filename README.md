# TFE import Organization

This module is a set of code to help you take control of a manual created HCP Terraform or Terraform Enterprise organization.

## Usage

Due to nature of Infrastructure of Code, terraform as a declarative language and this modules focus on the Import capabilities of the Terraform Cli and language block usage is beyond scope of the README. The `./examples` folder talks through utilizing this module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.8 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.55.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.55.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_teams.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/teams) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tfe_org"></a> [tfe\_org](#input\_tfe\_org) | name of the HCP terraform or Terraform enterprise organization | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_teams"></a> [teams](#output\_teams) | n/a |
<!-- END_TF_DOCS -->
