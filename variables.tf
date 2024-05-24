variable "tfc_org" {
  type        = string
  description = "name of the HCP terraform or Terraform enterprise organization"
}
variable "tfc_org_token" {
  type        = string
  description = "your TFC org level token, or token with sufficient permissions `export TF_VAR_tfc_org_token`"
}

#------------------------------------------------------------------------------
# Teams
#------------------------------------------------------------------------------
variable "team_access" {
  type        = map(string)
  description = "Map of existing Team(s) and built-in permissions to grant on Workspace."
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
  description = "(optional bool) Enable team imports, outputs and data"
  validation {
    condition     = contains(["all", "data", "false"], var.import_teams)
    error_message = "The variable can oply be one of ('all','data','false')"
  }
}
