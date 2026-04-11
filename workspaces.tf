data "tfe_workspace_ids" "this" {
  for_each     = contains(["data", "true"], var.import_workspaces) ? { "data" = "true" } : {}
  names        = ["*"]
  organization = var.tfc_org
}

data "terracurl_request" "workspaces" {
  for_each = var.import_workspaces == "data" ? { "data" = "true" } : {}
  name     = "workspaces"
  url      = "https://${var.tfe_hostname}/api/v2/organizations/${var.tfc_org}/workspaces"
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
  workspace_ids_map                 = contains(["data", "true"], var.import_workspaces) ? data.tfe_workspace_ids.this["data"].ids : {}
  terracurl_workspaces_response     = var.import_workspaces == "data" ? jsondecode(data.terracurl_request.workspaces["data"].response) : null
}

output "workspaces_import_map" {
  value       = local.workspace_ids_map
  description = "Output intended to be used for `var.workspaces_import_map` input"
}

output "terracurl_data_workspaces_response" {
  value       = var.import_workspaces == "data" ? local.terracurl_workspaces_response : null
  description = "The output from terracurl json response to the `workspaces` api endpoint"
}


import {
  for_each = var.import_workspaces == "true" && var.workspaces_import_map != null ? var.workspaces_import_map : {}
  to       = tfe_workspace.this[each.key]
  id       = each.value
}
resource "tfe_workspace" "this" {
  for_each     = var.import_workspaces == "true" && var.workspaces_import_map != null ? var.workspaces_import_map : {}
  name         = each.key
  organization = var.tfc_org
}
