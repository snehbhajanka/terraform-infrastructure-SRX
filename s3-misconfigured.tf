# Misconfigured S3 Bucket - INTENTIONALLY INSECURE
# This file contains security misconfigurations for demonstration purposes
# DO NOT use in production environments

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

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

# MISCONFIGURATION: Public read access to bucket
resource "aws_s3_bucket_public_access_block" "misconfigured_bucket_pab" {
  bucket = aws_s3_bucket.misconfigured_bucket.id

  # These should be true for security, but are false for misconfig demo
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# MISCONFIGURATION: Overly permissive bucket policy allowing public access
resource "aws_s3_bucket_policy" "misconfigured_bucket_policy" {
  bucket = aws_s3_bucket.misconfigured_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.misconfigured_bucket.arn}/*"
      },
      {
        Sid       = "PublicListBucket" 
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.misconfigured_bucket.arn
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
  bucket = aws_s3_bucket.misconfigured_bucket.id
  key    = "sample-data.txt"
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