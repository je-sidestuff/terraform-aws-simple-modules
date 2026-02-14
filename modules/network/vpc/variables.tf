# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "Name to be used on all resources as identifier"
  type        = string
}

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "A list of availability zone names in the region"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# SUBNET CONFIGURATION
# At least one of public_subnets or private_subnets should be provided.
# ---------------------------------------------------------------------------------------------------------------------

variable "public_subnets" {
  description = "A list of CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = []
}

# ---------------------------------------------------------------------------------------------------------------------
# NAT GATEWAY CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want a single shared NAT Gateway across all private networks"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Should be true if instances in public subnets get public IP on launch"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
