data "tfe_teams" "this" {
  for_each     = var.import_teams == "all" || var.import_teams == "data" ? { "data" = "true" } : {}
  organization = var.tfc_org
}
output "teams" {
  value = var.import_teams == "all" || var.import_teams == "data" ? data.tfe_teams.this : null
}
output "teams_import_list" {
  value = local.thelist
}
output "teams_import_map" {
  value = local.themap
}

locals {
  thelist = var.import_teams == "all" || var.import_teams == "data" ? formatlist("%s/%s", data.tfe_teams.this["data"].id, data.tfe_teams.this["data"].names) : []
  themap  = var.import_teams == "all" || var.import_teams == "data" ? zipmap(data.tfe_teams.this["data"].names, local.thelist) : {}
}
import {
  for_each = var.import_teams == "all" ? local.themap : {}
  to       = tfe_team.this[each.key]
  id       = each.value
}
resource "tfe_team" "this" {
  for_each = var.import_teams == "all" ? local.themap : {}
  name     = each.key
}
#TODO terracurl get org permissions from API
data "terracurl_request" "test" {
  name   = "products"
  url    = "https://api.releases.hashicorp.com/v1/organizations/${var.tfc_org}/teams"
  method = "GET"

  response_codes = [
    200
  ]

  max_retry      = 1
  retry_interval = 10
}
