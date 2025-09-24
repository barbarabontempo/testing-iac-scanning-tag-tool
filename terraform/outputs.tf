output "compliant_instance_id" {
  description = "ID of the compliant EC2 instance"
  value       = aws_instance.web_server_compliant.id
}

output "non_compliant_instance_id" {
  description = "ID of the non-compliant EC2 instance"
  value       = aws_instance.web_server_non_compliant.id
}

output "compliant_bucket_name" {
  description = "Name of the compliant S3 bucket"
  value       = aws_s3_bucket.data_bucket_compliant.bucket
}

output "non_compliant_bucket_name" {
  description = "Name of the non-compliant S3 bucket"
  value       = aws_s3_bucket.logs_bucket_non_compliant.bucket
}

