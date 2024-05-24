terraform {
  required_providers {
    tfe = {
      version = "~> 0.55.0"
    }
  }
}
provider "tfe" {
}

data "tfe_teams" "this" {
  organization = var.tfe_org
}
output "teams" {
  value = data.tfe_teams.this
}

# import {
#   for_each = data.tfe_teams.this.ids
#   to       = tfe_team.this[each.key]
#   id       = each.value
# }
# resource "tfe_team" "this" {
#   for_each = data.tfe_teams.this.ids
#   name     = data.tfe_teams.this[each.key]
# }
