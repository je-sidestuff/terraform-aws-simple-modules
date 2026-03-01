output "bucket_name" {
  description = "The name of the S3 bucket storing Terraform state."
  value       = aws_s3_bucket.terraform_state.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket storing Terraform state."
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state locking."
  value       = aws_dynamodb_table.terraform_locks.id
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table used for state locking."
  value       = aws_dynamodb_table.terraform_locks.arn
}

output "migrate_state_command" {
  description = "The command to migrate state to the new S3 backend."
  value       = "terraform init -input=false -migrate-state -force-copy"
}

output "terragrunt_backend_generator" {
  description = "The generated Terragrunt backend configuration."
  value = templatefile("${path.module}/backend-generator.hcl.tmpl", {
    bucket         = aws_s3_bucket.terraform_state.id
    dynamodb_table = aws_dynamodb_table.terraform_locks.id
    region         = data.aws_region.current.name
    key_string     = "$${path_relative_to_include()}/terraform.tfstate"
  })
}

output "scoping_tags" {
  description = "Tags to apply to resources within this state's scope. Includes user-provided tags plus optional random seed and creation timestamp."
  value       = local.scoping_tags
}
