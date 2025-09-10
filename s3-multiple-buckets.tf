# Multiple Misconfigured S3 Buckets - INTENTIONALLY INSECURE
# This file creates 5 S3 buckets with security misconfigurations for demonstration purposes
# DO NOT use in production environments
# Note: This file extends the existing infrastructure and should be used alongside the existing files

# Random suffix for unique bucket names (separate from existing one)
resource "random_id" "multiple_buckets_suffix" {
  byte_length = 4
}

# Bucket configurations for iteration
locals {
  bucket_configs = {
    1 = {
      name_suffix = "web-assets"
      display_name = "Public Web Assets Bucket"
      sample_file = {
        key = "index.html"
        content = "<html><body><h1>Public Web Assets - Insecure Bucket 1</h1></body></html>"
        content_type = "text/html"
        purpose = "Demo Web Content"
      }
    }
    2 = {
      name_suffix = "downloads"
      display_name = "Public Downloads Bucket"
      sample_file = {
        key = "download.txt"
        content = "This is a sample download file in an insecure bucket"
        content_type = "text/plain"
        purpose = "Demo Download"
      }
    }
    3 = {
      name_suffix = "media"
      display_name = "Public Media Bucket"
      sample_file = {
        key = "media.txt"
        content = "Sample media file metadata in an insecure bucket"
        content_type = "text/plain"
        purpose = "Demo Media"
      }
    }
    4 = {
      name_suffix = "documents"
      display_name = "Public Documents Bucket"
      sample_file = {
        key = "document.txt"
        content = "Sensitive document content that should not be public"
        content_type = "text/plain"
        purpose = "Demo Document"
      }
    }
    5 = {
      name_suffix = "backups"
      display_name = "Public Backups Bucket"
      sample_file = {
        key = "backup.sql"
        content = "-- Database backup file with sensitive data\nCREATE TABLE users (id INT, password VARCHAR(255));"
        content_type = "application/sql"
        purpose = "Demo Backup"
      }
    }
  }
}

# MISCONFIGURED S3 Buckets - Iterating over configurations
resource "aws_s3_bucket" "public_bucket" {
  for_each = local.bucket_configs
  
  bucket = "public-${each.value.name_suffix}-${random_id.multiple_buckets_suffix.hex}"
  
  # MISCONFIGURATION: Force destroy allows deletion even with objects
  force_destroy = true

  tags = {
    Name        = each.value.display_name
    Environment = "Demo"
    Purpose     = "Security Testing"
    BucketNumber = each.key
  }
}

# MISCONFIGURATION: Public read access to all buckets
resource "aws_s3_bucket_public_access_block" "public_bucket_pab" {
  for_each = local.bucket_configs
  
  bucket = aws_s3_bucket.public_bucket[each.key].id

  # These should be true for security, but are false for misconfig demo
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# MISCONFIGURATION: Overly permissive bucket policy allowing public access for all buckets
resource "aws_s3_bucket_policy" "public_bucket_policy" {
  for_each = local.bucket_configs
  
  bucket = aws_s3_bucket.public_bucket[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket[each.key].arn}/*"
      },
      {
        Sid       = "PublicListBucket" 
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.public_bucket[each.key].arn
      }
    ]
  })
}

# MISCONFIGURATION: No server-side encryption configured for any buckets
# Missing aws_s3_bucket_server_side_encryption_configuration for all buckets

# MISCONFIGURATION: No versioning enabled for any buckets
# Missing aws_s3_bucket_versioning for all buckets

# MISCONFIGURATION: No access logging for any buckets
# Missing aws_s3_bucket_logging for all buckets

# Sample objects with insecure content
resource "aws_s3_object" "sample_file" {
  for_each = local.bucket_configs
  
  bucket = aws_s3_bucket.public_bucket[each.key].id
  key    = each.value.sample_file.key
  content = each.value.sample_file.content
  
  # MISCONFIGURATION: No server-side encryption for object
  content_type = each.value.sample_file.content_type

  tags = {
    Purpose = each.value.sample_file.purpose
  }
}

# Outputs for all buckets using for_each
output "bucket_names" {
  description = "Names of all public S3 buckets"
  value = {
    for k, v in aws_s3_bucket.public_bucket : k => v.id
  }
}

output "bucket_arns" {
  description = "ARNs of all public S3 buckets" 
  value = {
    for k, v in aws_s3_bucket.public_bucket : k => v.arn
  }
}

output "bucket_domain_names" {
  description = "Domain names of all public S3 buckets"
  value = {
    for k, v in aws_s3_bucket.public_bucket : k => v.bucket_domain_name
  }
}

# Summary output
output "all_bucket_names" {
  description = "List of all public bucket names"
  value = [
    for bucket in aws_s3_bucket.public_bucket : bucket.id
  ]
}