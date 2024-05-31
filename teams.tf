data "tfe_teams" "this" {
  for_each     = var.import_teams == "true" || var.import_teams == "data" ? { "data" = "true" } : {}
  organization = var.tfc_org
}

data "terracurl_request" "teams" {
  for_each = var.import_teams == "data" ? { "data" = "true" } : {}
  name     = "teams"
  url      = "https://${var.tfe_hostname}/api/v2/organizations/${var.tfc_org}/teams"
  method   = "GET"

  response_codes = [
    200
  ]

  max_retry      = 1
  retry_interval = 10
  headers = {
    Authorization = "Bearer ${var.tfc_org_token}"
    Content-Type  = "application/vnd.api+json"
  }
}
locals {
  team_list                = contains(["true", "data"], var.import_teams) ? formatlist("%s/%s", data.tfe_teams.this["data"].id, data.tfe_teams.this["data"].names) : []
  team_map                 = contains(["true", "data"], var.import_teams) ? zipmap(data.tfe_teams.this["data"].names, local.team_list) : {}
  terracurl_teams_response = contains(["data"], var.import_teams) ? jsondecode(data.terracurl_request.teams["data"].response) : null
}
output "teams" {
  value       = var.import_teams == "true" || var.import_teams == "data" ? data.tfe_teams.this : null
  description = "Output for teams data_source"
}
output "teams_import_map" {
  value       = local.team_map
  description = "Output intended to be used for `var.teams_import_map` input"
}
output "terracurl_data_teams_response" {
  value       = local.terracurl_teams_response
  description = "The output from terracurl json response to the `teams` api endpoint"
}


import {
  for_each = var.import_teams == "true" && var.teams_import_map != null ? var.teams_import_map : {}
  to       = tfe_team.this[each.key]
  id       = each.value
}
resource "tfe_team" "this" {
  for_each = var.import_teams == "true" && var.teams_import_map != null ? var.teams_import_map : {}
  name     = each.key
}
