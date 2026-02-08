# ---------------------------------------------------------------------------------------------------------------------
# SIMPLE ALB EXAMPLE
# This example demonstrates how to use the ALB module with a fixed response.
# ---------------------------------------------------------------------------------------------------------------------

locals {
  name_prefix = lower("ex-${module.example_helpers.random_value}-alb")
}

module "example_helpers" {
  source = "github.com/je-sidestuff/terraform-example-helpers.git?ref=v0.0.1"

  example_seed = var.example_seed
}

# ---------------------------------------------------------------------------------------------------------------------
# DATA SOURCES
# Fetch VPC and subnet information.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUP
# Allow inbound HTTP traffic.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-sg"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${local.name_prefix}-sg"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ALB MODULE
# Create an Application Load Balancer with a fixed response.
# ---------------------------------------------------------------------------------------------------------------------

module "alb" {
  source = "../../..//modules/alb"

  name        = local.name_prefix
  environment = "example"
  vpc_id      = data.aws_vpc.default.id
  subnets     = data.aws_subnets.default.ids

  security_groups = [aws_security_group.alb.id]

  enable_http = true

  default_action_type         = "fixed-response"
  fixed_response_content_type = "text/plain"
  fixed_response_message_body = "You have reached example ${local.name_prefix}."
  fixed_response_status_code  = "200"
}
