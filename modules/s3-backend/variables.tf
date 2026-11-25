variable "bucket_name" {
  description = "Unique name for the S3 bucket storing Terraform state"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}
