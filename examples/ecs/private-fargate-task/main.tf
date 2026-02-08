locals {
  name_prefix = lower("ex-${module.example_helpers.random_value}-ecs")

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

data "aws_availability_zones" "available" {}

module "example_helpers" {
  source = "github.com/je-sidestuff/terraform-example-helpers.git?ref=temp1"

  example_seed = var.example_seed
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name_prefix}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = "${local.name_prefix}-alb"

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # For example only
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }
  
  listeners = {
    ex_http = {
      port            = 80
      protocol        = "HTTP"

      forward = {
        target_group_key = "ex_ecs"
      }
    }
  }

  target_groups = {
    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      # ECS will attach the IPs
      create_attachment = false
    }
  }

  tags = {
    Terraform = "true"
  }
}

# Use the fargate-task module
module "minimal_fargate_task" {
  source = "../../..//modules/ecs/fargate-task"

  cluster_name           = "${local.name_prefix}-cluster"
  container_name         = "nginx"
  container_image        = "nginx:latest"
  container_port         = 80
  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.private_subnets
  assign_public_ip       = false
  alb_target_group_arn   = module.alb.target_groups["ex_ecs"].arn

  tags = {
    Environment = "example"
    Project     = "minimal-fargate"
  }
}
