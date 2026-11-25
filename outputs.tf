output "s3_bucket_name" {
  description = "Name of the S3 bucket created for remote state"
  value       = module.s3_backend.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket created for remote state"
  value       = module.s3_backend.bucket_arn
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the created public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the created private subnet"
  value       = module.vpc.private_subnet_id
}
