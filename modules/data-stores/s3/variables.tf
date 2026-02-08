# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "versioning_enabled" {
  type        = bool
  description = "Enable versioning on the S3 bucket"
  default     = true
}

variable "encryption_algorithm" {
  type        = string
  description = "Server-side encryption algorithm to use"
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.encryption_algorithm)
    error_message = "Encryption algorithm must be either AES256 or aws:kms."
  }
}

variable "block_public_access" {
  type        = bool
  description = "Whether to block public access to the bucket"
  default     = true
}

variable "allowed_principals" {
  type        = list(string)
  description = "List of AWS principal ARNs that should have access to the bucket"
  default     = []
}

variable "allowed_actions" {
  type        = list(string)
  description = "List of S3 actions to allow for the specified principals"
  default = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
    "s3:ListBucket"
  ]
}

variable "force_destroy" {
  type        = bool
  description = "Force the destruction of the s3 bucket even if it contains data."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources"
  default     = {}
}