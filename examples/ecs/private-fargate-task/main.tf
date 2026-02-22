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
  source = "../../..//modules/network/vpc"

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
  source = "../../..//modules/alb"

  name        = local.name_prefix
  environment = "dev"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets

  enable_http = true
  target_type = "ip" # Required for ECS Fargate tasks
}

# Create an IAM role for the ECS task with read-only access
module "task_role" {
  source = "../../..//modules/iam/role"

  name = "${local.name_prefix}-task-role"

  assume_role_principals = {
    ecs = true
  }

  policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]

  tags = {
    Environment = "example"
    Project     = "minimal-fargate"
  }
}

# Use the fargate-task module
module "minimal_fargate_task" {
  source = "../../..//modules/ecs/fargate-task"

  cluster_name       = "${local.name_prefix}-cluster"
  container_name     = "nginx"
  container_image    = "nginx:latest"
  container_port     = 80
  container_protocol = "tcp"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.private_subnets
  assign_public_ip   = false
  alb_target_group_arn = module.alb.target_group_arn
  task_role_arn        = module.task_role.role_arn

  tags = {
    Environment = "example"
    Project     = "minimal-fargate"
  }
}
