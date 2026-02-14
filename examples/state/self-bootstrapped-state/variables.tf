# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

# None!

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_remote" {
  description = "The current configuration for the module to use. By first setting this to false and applying we can safely destroy."
  type        = bool
  default     = true
}

variable "naming_prefix" {
  type        = string
  description = "A prefix to use for naming the state resources. Set to 'generate' to auto-generate a random prefix."
  default     = "generate"
}

variable "region" {
  description = "The AWS region where the state resources will be deployed."
  type        = string
  default     = "us-east-2"
}

variable "tags" {
  description = "Tags to be added to the state resources."
  type        = map(string)
  default     = {}
}
