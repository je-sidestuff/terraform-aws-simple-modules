locals {
  name_prefix = lower("ex-${module.example_helpers.random_value}-ecs")
}

module "example_helpers" {
  source = "github.com/je-sidestuff/terraform-example-helpers.git?ref=v0.0.1"

  example_seed = var.example_seed
}

module "s3" {
  source = "../../..//modules/data-stores/s3"

  force_destroy = true

  bucket_name = "${local.name_prefix}-s3"
}