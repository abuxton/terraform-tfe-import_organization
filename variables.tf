variable "tfc_org" {
  type        = string
  description = "(Required) Name of the HCP terraform or Terraform enterprise organization"
}
variable "tfe_hostname" {
  type        = string
  description = "(Optional sting) Terraform Enterprise server hostname defaults to HCP terraforms hostname `app.terraform.io`"
  default     = "app.terraform.io"
}
variable "tfc_org_token" {
  type        = string
  description = "(Required Sensitive) Your TFC Org or Owners team level token, or token with sufficient permissions `export TF_VAR_tfc_org_token=TF_TOKEN`"
  sensitive   = true
}


#------------------------------------------------------------------------------
# Teams
#------------------------------------------------------------------------------
variable "teams_import_map" {
  type        = map(any)
  description = "(Optional Map) This map of Strings is intended to be populated by capturing the output of `terarform output teams_import_map`"
  default     = {}
}

variable "import_teams" {
  type        = string
  default     = "false"
  description = "(Optional [\"true\", \"data\", \"false\"]) Enable team imports, import data output, and initial API data capture"
  validation {
    condition     = contains(["true", "data", "false"], var.import_teams)
    error_message = "The variable can oply be one of ('true','data','false')"
  }
}

