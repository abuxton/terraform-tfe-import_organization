# Team resources

## Usage

```json
variable "tfc_org" {
  type        = string
  description = "name of the HCP terraform or Terraform enterprise organization"
}

locals{
tfc_org = var.tfc_org
}

provider "tfe"{
 organization = local.tfc_org
}

module "import_org_teams" {
	source = "../.."
	tfc_org = local.tfc_org

}

output "this" {
	value=module.import_org_teams.output
}

```
