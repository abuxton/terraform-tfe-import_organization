
variable "tfc_org" {
  type        = string
  description = "name of the HCP terraform or Terraform enterprise organization"
}
variable "tfc_org_token" {
  type        = string
  description = "your TFC org level token, or token with sufficient permissions `export TF_VAR_tfc_org_token`"
  sensitive   = true
}

locals {
  tfc_org = var.tfc_org

}

provider "tfe" {
  organization = local.tfc_org
  alias        = "org"
}
module "example" {
  source        = "../.."
  tfc_org       = local.tfc_org
  tfc_org_token = var.tfc_org
  providers {
    tfe = tfe.org
  }
}

output "this" {
  value = module.import_org_teams.output
}


