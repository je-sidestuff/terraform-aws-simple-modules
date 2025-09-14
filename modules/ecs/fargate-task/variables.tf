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

variable "tags" {
    type = map(string)
    default = {}
}
