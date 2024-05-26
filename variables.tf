variable "tfc_org" {
  type        = string
  description = "(Required) Name of the HCP terraform or Terraform enterprise organization"
}
variable "tfc_org_token" {
  type        = string
  description = "(Required Sensitive) Your TFC Org or Owners team level token, or token with sufficient permissions `export TF_VAR_tfc_org_token=TF_TOKEN`"
  sensitive   = true
}

#------------------------------------------------------------------------------
# Teams
#------------------------------------------------------------------------------
variable "team_access" {
  type        = map(string)
  description = "Map of existing Team(s) and built-in permissions to grant on Workspace."
  default     = {}
}
variable "teams_import_map" {
  type = map(
    object(
      {
        team         = string
        org_and_team = string
      }
    )
  )
  description = "(Optional Map) This map is intended to be populated by capturing the output of `terarform output teams_import_map`"
  default     = {}
}
variable "custom_team_access" {
  type = map(
    object(
      {
        runs              = string
        variables         = string
        state_versions    = string
        sentinel_mocks    = string
        workspace_locking = bool
        run_tasks         = bool
      }
    )
  )
  description = "Map of existing Team(s) and custom permissions to grant on Workspace. If used, all keys in the object must be specified."
  default     = {}
}

variable "import_teams" {
  type        = string
  default     = "false"
  description = "(optional [\"true\", \"data\", \"false\"]) Enable team imports, import data output, and initial API data capture"
  validation {
    condition     = contains(["true", "data", "false"], var.import_teams)
    error_message = "The variable can oply be one of ('true','data','false')"
  }
}
