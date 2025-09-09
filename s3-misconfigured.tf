# Misconfigured S3 Bucket - INTENTIONALLY INSECURE
# This file contains security misconfigurations for demonstration purposes
# DO NOT use in production environments

# Get current AWS account ID for secure bucket policy
data "aws_caller_identity" "current" {}

# Misconfigured S3 bucket with multiple security issues
resource "aws_s3_bucket" "misconfigured_bucket" {
  bucket = "my-insecure-bucket-${random_id.bucket_suffix.hex}"

  # MISCONFIGURATION: Force destroy allows deletion even with objects
  force_destroy = true

  tags = {
    Name        = "Misconfigured Bucket"
    Environment = "Demo"
    Purpose     = "Security Testing"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# SECURITY FIX: Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "misconfigured_bucket_pab" {
  bucket = aws_s3_bucket.misconfigured_bucket.id

  # Security best practice: Block all public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SECURITY FIX: Restrictive bucket policy - only allows access from AWS account owner
resource "aws_s3_bucket_policy" "misconfigured_bucket_policy" {
  bucket = aws_s3_bucket.misconfigured_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "RestrictedAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.misconfigured_bucket.arn,
          "${aws_s3_bucket.misconfigured_bucket.arn}/*"
        ]
      }
    ]
  })
}

# MISCONFIGURATION: No server-side encryption configured
# Missing aws_s3_bucket_server_side_encryption_configuration

# MISCONFIGURATION: No versioning enabled  
# Missing aws_s3_bucket_versioning

# MISCONFIGURATION: No access logging
# Missing aws_s3_bucket_logging

# MISCONFIGURATION: No lifecycle configuration (objects never expire)
# Missing aws_s3_bucket_lifecycle_configuration

# Sample object with insecure content type
resource "aws_s3_object" "sample_file" {
  bucket  = aws_s3_bucket.misconfigured_bucket.id
  key     = "sample-data.txt"
  content = "This is sample data in an insecure bucket"

  # MISCONFIGURATION: No server-side encryption for object
  # Missing server_side_encryption

  content_type = "text/plain"

  tags = {
    Purpose = "Demo Data"
  }
}

# Outputs
output "bucket_name" {
  description = "Name of the misconfigured S3 bucket"
  value       = aws_s3_bucket.misconfigured_bucket.id
}

output "bucket_arn" {
  description = "ARN of the misconfigured S3 bucket"
  value       = aws_s3_bucket.misconfigured_bucket.arn
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.misconfigured_bucket.bucket_domain_name
}