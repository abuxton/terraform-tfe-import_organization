data "tfe_organization" "this" {
  for_each = contains(["data", "true"], var.import_organization) ? { "data" = "true" } : {}
  name     = var.tfc_org
}

data "terracurl_request" "organization" {
  for_each = var.import_organization == "data" ? { "data" = "true" } : {}
  name     = "organization"
  url      = "https://${var.tfe_hostname}/api/v2/organizations/${var.tfc_org}"
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
  terracurl_organization_response = var.import_organization == "data" ? jsondecode(data.terracurl_request.organization["data"].response) : null
}

output "organization" {
  value       = contains(["data", "true"], var.import_organization) ? data.tfe_organization.this["data"] : null
  description = "Output for organization data source"
}

output "terracurl_data_organization_response" {
  value       = var.import_organization == "data" ? local.terracurl_organization_response : null
  description = "The output from terracurl json response to the `organization` api endpoint"
}


import {
  for_each = var.import_organization == "true" ? { (var.tfc_org) = var.tfc_org } : {}
  to       = tfe_organization.this[each.key]
  id       = each.value
}
resource "tfe_organization" "this" {
  for_each = var.import_organization == "true" ? { (var.tfc_org) = var.tfc_org } : {}
  name     = each.key
  email    = data.tfe_organization.this["data"].email
}
