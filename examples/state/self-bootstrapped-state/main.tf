locals {
  naming_prefix       = var.naming_prefix == "generate" ? "ex-${random_string.random.result}" : var.naming_prefix
  bucket_name         = "${local.naming_prefix}-tfstate"
  dynamodb_table_name = "${local.naming_prefix}-tfstate-locks"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

module "state" {
  source = "../../..//modules/state/self-bootstrapped-state"

  enable_remote = var.enable_remote

  bucket_name         = local.bucket_name
  dynamodb_table_name = local.dynamodb_table_name

  bootstrap_styles                    = ["terraform", "terragrunt"]
  terragrunt_backend_generator_folder = "${path.root}/terragrunt-mock"

  tags = var.tags
}
