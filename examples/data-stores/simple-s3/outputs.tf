output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = module.s3.bucket_name
}

output "s3_upload_command" {
  description = "AWS CLI command to upload a file to the S3 bucket"
  value       = "aws s3 cp ${path.root}/main.tf s3://${module.s3.bucket_name}/"
}