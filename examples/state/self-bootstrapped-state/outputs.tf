output "bucket_name" {
  description = "The name of the S3 bucket storing Terraform state."
  value       = module.state.bucket_name
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket storing Terraform state."
  value       = module.state.bucket_arn
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for state locking."
  value       = module.state.dynamodb_table_name
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table used for state locking."
  value       = module.state.dynamodb_table_arn
}

output "migrate_state_command" {
  description = "The command to migrate state to the new S3 backend."
  value       = module.state.migrate_state_command
}
