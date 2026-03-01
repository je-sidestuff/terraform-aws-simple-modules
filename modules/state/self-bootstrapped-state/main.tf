# ---------------------------------------------------------------------------------------------------------------------
# SCOPING TAGS
# These tags can be used by other modules to scope resources to this state
# ---------------------------------------------------------------------------------------------------------------------

resource "random_string" "scope_seed" {
  count   = var.scoping_tags_include_random ? 1 : 0
  length  = 4
  special = false
  upper   = false
}

resource "time_static" "scope_creation" {
  count = var.scoping_tags_include_creation_timestamp ? 1 : 0
}

locals {
  scoping_tags = merge(
    var.scoping_tags,
    var.scoping_tags_include_random ? {
      "state-seed" = "${var.bucket_name}-${random_string.scope_seed[0].result}"
    } : {},
    var.scoping_tags_include_creation_timestamp ? {
      "state-created" = time_static.scope_creation[0].rfc3339
    } : {}
  )

  all_tags = merge(local.scoping_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKET FOR TERRAFORM STATE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  force_destroy = !var.enable_remote

  tags = local.all_tags
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------------------------------------------------------------------------------------------------------------------
# DYNAMODB TABLE FOR STATE LOCKING
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.all_tags
}

# ---------------------------------------------------------------------------------------------------------------------
# BACKEND CONFIGURATION FILES
# These are generated to help with state migration
# ---------------------------------------------------------------------------------------------------------------------

resource "local_file" "terraform_backend" {
  count = (contains(var.bootstrap_styles, "terraform") && var.enable_remote) ? 1 : 0

  content = templatefile("${path.module}/backend.tf.tmpl", {
    bucket         = aws_s3_bucket.terraform_state.id
    dynamodb_table = aws_dynamodb_table.terraform_locks.id
    region         = data.aws_region.current.name
    state_key      = var.state_key
  })
  filename = "${path.root}/backend.tf"
}

resource "local_file" "terragrunt_generator" {
  count = (contains(var.bootstrap_styles, "terragrunt") && var.enable_remote) ? 1 : 0

  content = templatefile("${path.module}/backend-generator.hcl.tmpl", {
    bucket         = aws_s3_bucket.terraform_state.id
    dynamodb_table = aws_dynamodb_table.terraform_locks.id
    region         = data.aws_region.current.name
    key_string     = "$${path_relative_to_include()}/terraform.tfstate"
  })
  filename = "${var.terragrunt_backend_generator_folder}/backend-generator.hcl"

  lifecycle {
    precondition {
      condition     = var.terragrunt_backend_generator_folder != ""
      error_message = "The terragrunt_backend_generator_folder must be set if bootstrap_style includes terragrunt"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DATA SOURCES
# ---------------------------------------------------------------------------------------------------------------------

data "aws_region" "current" {}
