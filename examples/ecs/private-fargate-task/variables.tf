# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

# Nope!

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "example_seed" {
  type        = string
  description = "A string which will override the random value output if provided on initial creation. If the value is provided or changed on an already-created example it will have no effect."
  default     = ""
}

variable "naming_prefix" {
  type        = string
  description = "A prefix to use for naming the fargate task and supporting resources."
  default     = "generate"
}

variable "region" {
  description = "The the region where the DB is located."
  type        = string
  default     = "eu-west-1"
}
