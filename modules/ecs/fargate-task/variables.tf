# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
    type = string

}

variable "subnets" {
    type = list(string)

}

variable "assign_public_ip" {
    type = bool
    
}

variable "alb_target_group_arn" {
    type = string
    
}

variable "container_name" {
    type = string
    
}

variable "container_port" {
    type = number

}

variable "container_protocol" {
    description = "The IP protocol for container traffic (tcp or udp). Required when specifying ports in security group rules."
    type        = string
    default     = "tcp"

    validation {
        condition     = contains(["tcp", "udp"], var.container_protocol)
        error_message = "container_protocol must be 'tcp' or 'udp'."
    }
}

variable "container_image" {
    type = string
    
}

variable "vpc_id" {
  type = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "task_role_arn" {
  type        = string
  description = "ARN of the IAM role for the ECS task to assume. This role grants permissions to the container."
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
