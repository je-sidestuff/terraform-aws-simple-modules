# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the Load Balancer."
  type        = string
}

variable "environment" {
  description = "The environment the load balancer will be run in."
  type        = string
}

variable "subnets" {
  description = "The IDs of the subnets this LB belongs to."
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to attach this load balancer to."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "internal" {
  description = "Whether this LB can only accept private traffic."
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "The security groups to associate with the load balancer."
  type        = list(string)
  default     = []
}

variable "target_port" {
  description = "The port where traffic will be directed once received if not overridden."
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "The path for health check requests."
  type        = string
  default     = "/"
}

variable "target_type" {
  description = "The type of target for the target group. Valid values: 'instance', 'ip', or 'lambda'. Use 'ip' for ECS Fargate tasks."
  type        = string
  default     = "instance"

  validation {
    condition     = contains(["instance", "ip", "lambda"], var.target_type)
    error_message = "target_type must be 'instance', 'ip', or 'lambda'."
  }
}

variable "default_action_type" {
  description = "The type of default action for the listener. Valid values: 'forward' or 'fixed-response'."
  type        = string
  default     = "forward"

  validation {
    condition     = contains(["forward", "fixed-response"], var.default_action_type)
    error_message = "default_action_type must be 'forward' or 'fixed-response'."
  }
}

variable "fixed_response_content_type" {
  description = "The content type for the fixed response. Only used when default_action_type is 'fixed-response'."
  type        = string
  default     = "text/plain"
}

variable "fixed_response_message_body" {
  description = "The message body for the fixed response. Only used when default_action_type is 'fixed-response'."
  type        = string
  default     = "OK"
}

variable "fixed_response_status_code" {
  description = "The HTTP status code for the fixed response. Only used when default_action_type is 'fixed-response'."
  type        = string
  default     = "200"
}

# ---------------------------------------------------------------------------------------------------------------------
# LISTENER CONFIGURATION
# Configure which ports and protocols to enable.
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_http" {
  description = "Whether to enable the HTTP listener on port 80."
  type        = bool
  default     = false
}

variable "enable_https" {
  description = "Whether to enable the HTTPS listener on port 443."
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate to serve. Required when enable_https is true."
  type        = string
  default     = null
}

variable "redirect_http_to_https" {
  description = "When both HTTP and HTTPS are enabled, redirect HTTP traffic to HTTPS instead of forwarding to target group."
  type        = bool
  default     = true
}

variable "ssl_policy" {
  description = "The SSL policy for the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

# ---------------------------------------------------------------------------------------------------------------------
# DNS CONFIGURATION (OPTIONAL)
# Configure Route53 DNS record for the load balancer.
# ---------------------------------------------------------------------------------------------------------------------

variable "create_dns_record" {
  description = "Whether to create a Route53 DNS record for the load balancer."
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "The ID of the Route53 hosted zone. Required when create_dns_record is true."
  type        = string
  default     = null
}

variable "domain" {
  description = "The domain name to alias to the load balancer. Required when create_dns_record is true."
  type        = string
  default     = null
}
