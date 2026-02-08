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

variable "region" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "eu-west-1"
}
