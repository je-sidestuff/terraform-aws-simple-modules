# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "The name of the IAM role"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "assume_role_principals" {
  type = object({
    ecs            = optional(bool, false)
    aws_principals = optional(list(string), [])
  })
  description = "Configuration for the trust policy. Set ecs=true to allow ECS tasks to assume this role. Provide aws_principals as a list of AWS principal ARNs."
  default     = {}
}

variable "policy_arns" {
  type        = list(string)
  description = "List of IAM policy ARNs to attach to this role"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources"
  default     = {}
}
