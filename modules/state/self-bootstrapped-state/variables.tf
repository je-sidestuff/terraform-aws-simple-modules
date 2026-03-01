# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state files."
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state locking."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "bootstrap_styles" {
  description = "To use this module for a direct tofu/terraform bootstrap or a terragrunt bootstrap."
  type        = list(string)
  default     = ["terraform"]
  validation {
    condition     = alltrue([for v in var.bootstrap_styles : contains(["terraform", "terragrunt"], v)])
    error_message = "Acceptable values for 'bootstrap_style' are 'terraform' and 'terragrunt'."
  }
}

variable "enable_remote" {
  description = "The current configuration for the module to use. By first setting this to false and applying we can safely destroy."
  type        = bool
  default     = true
}

variable "terragrunt_backend_generator_folder" {
  description = "The path to the folder where the terragrunt backend generator will be deployed. Only used if bootstrap_style includes terragrunt."
  type        = string
  default     = ""
}

variable "state_key" {
  description = "The S3 key for the Terraform state file when generating backend configuration."
  type        = string
  default     = "root.tfstate"
}

variable "scoping_tags" {
  description = "A map of tags to apply to all resources using this state (including the resources here)."
  type        = map(string)
  default     = {}
}

variable "scoping_tags_include_random" {
  description = "Add a tag based on this bucket name and a random 4-character alphanumeric seed."
  type        = bool
  default     = true
}

variable "scoping_tags_include_creation_timestamp" {
  description = "Add a tag to mark the creation time of this state's scope."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
