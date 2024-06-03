

data "terracurl_request" "projects" {
  for_each = contains(["data", "true"], var.import_projects) ? { "data" = "true" } : {}
  name     = "projects"
  url      = "https://${var.tfe_hostname}/api/v2/organizations/${var.tfc_org}/projects"
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
  terracurl_projects_response = contains(["data", "true"], var.import_projects) ? jsondecode(data.terracurl_request.projects["data"].response) : null
  #https://developer.hashicorp.com/terraform/language/expressions/function-calls#expanding-function-arguments
  terracurl_projects_map = contains(["data", "true"], var.import_projects) ? merge([for projects in local.terracurl_projects_response["data"] : {
    "${projects.attributes.name}" = projects.id
  }]...) : null
}


output "projects_import_map" {
  value       = local.terracurl_projects_map
  description = "Output intended to be used for `var.projects_import_map` input"
}

output "terracurl_data_projects_response" {
  value       = contains(["data"], var.import_projects) ? local.terracurl_projects_response : null
  description = "The output from terracurl json response to the `projects` api endpoint"
}


import {
  for_each = var.import_projects == "true" && var.projects_import_map != null ? var.projects_import_map : {}
  to       = tfe_project.this[each.key]
  id       = each.value
}
resource "tfe_project" "this" {
  for_each = var.import_projects == "true" && var.projects_import_map != null ? var.projects_import_map : {}
  name     = each.key
}
