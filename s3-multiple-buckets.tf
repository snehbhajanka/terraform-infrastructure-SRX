# Multiple Misconfigured S3 Buckets - INTENTIONALLY INSECURE
# This file creates 5 S3 buckets with security misconfigurations for demonstration purposes
# DO NOT use in production environments
# Note: This file extends the existing infrastructure and should be used alongside the existing files

# Random suffix for unique bucket names (separate from existing one)
resource "random_id" "multiple_buckets_suffix" {
  byte_length = 4
}

# MISCONFIGURED S3 Bucket 1 - Public Web Assets
resource "aws_s3_bucket" "public_bucket_1" {
  bucket = "public-web-assets-${random_id.multiple_buckets_suffix.hex}"
  
  # MISCONFIGURATION: Force destroy allows deletion even with objects
  force_destroy = true

  tags = {
    Name        = "Public Web Assets Bucket"
    Environment = "Demo"
    Purpose     = "Security Testing"
    BucketNumber = "1"
  }
}

# MISCONFIGURATION: Public read access to bucket 1
resource "aws_s3_bucket_public_access_block" "public_bucket_1_pab" {
  bucket = aws_s3_bucket.public_bucket_1.id

  # These should be true for security, but are false for misconfig demo
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# MISCONFIGURATION: Overly permissive bucket policy allowing public access for bucket 1
resource "aws_s3_bucket_policy" "public_bucket_1_policy" {
  bucket = aws_s3_bucket.public_bucket_1.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket_1.arn}/*"
      },
      {
        Sid       = "PublicListBucket" 
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.public_bucket_1.arn
      }
    ]
  })
}

# MISCONFIGURED S3 Bucket 2 - Public Downloads
resource "aws_s3_bucket" "public_bucket_2" {
  bucket = "public-downloads-${random_id.multiple_buckets_suffix.hex}"
  
  # MISCONFIGURATION: Force destroy allows deletion even with objects
  force_destroy = true

  tags = {
    Name        = "Public Downloads Bucket"
    Environment = "Demo"
    Purpose     = "Security Testing"
    BucketNumber = "2"
  }
}

# MISCONFIGURATION: Public read access to bucket 2
resource "aws_s3_bucket_public_access_block" "public_bucket_2_pab" {
  bucket = aws_s3_bucket.public_bucket_2.id

  # These should be true for security, but are false for misconfig demo
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# MISCONFIGURATION: Overly permissive bucket policy allowing public access for bucket 2
resource "aws_s3_bucket_policy" "public_bucket_2_policy" {
  bucket = aws_s3_bucket.public_bucket_2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket_2.arn}/*"
      },
      {
        Sid       = "PublicListBucket" 
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.public_bucket_2.arn
      }
    ]
  })
}

# MISCONFIGURED S3 Bucket 3 - Public Media
resource "aws_s3_bucket" "public_bucket_3" {
  bucket = "public-media-${random_id.multiple_buckets_suffix.hex}"
  
  # MISCONFIGURATION: Force destroy allows deletion even with objects
  force_destroy = true

  tags = {
    Name        = "Public Media Bucket"
    Environment = "Demo"
    Purpose     = "Security Testing"
    BucketNumber = "3"
  }
}

# MISCONFIGURATION: Public read access to bucket 3
resource "aws_s3_bucket_public_access_block" "public_bucket_3_pab" {
  bucket = aws_s3_bucket.public_bucket_3.id

  # These should be true for security, but are false for misconfig demo
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# MISCONFIGURATION: Overly permissive bucket policy allowing public access for bucket 3
resource "aws_s3_bucket_policy" "public_bucket_3_policy" {
  bucket = aws_s3_bucket.public_bucket_3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket_3.arn}/*"
      },
      {
        Sid       = "PublicListBucket" 
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.public_bucket_3.arn
      }
    ]
  })
}

# MISCONFIGURED S3 Bucket 4 - Public Documents
resource "aws_s3_bucket" "public_bucket_4" {
  bucket = "public-documents-${random_id.multiple_buckets_suffix.hex}"
  
  # MISCONFIGURATION: Force destroy allows deletion even with objects
  force_destroy = true

  tags = {
    Name        = "Public Documents Bucket"
    Environment = "Demo"
    Purpose     = "Security Testing"
    BucketNumber = "4"
  }
}

# MISCONFIGURATION: Public read access to bucket 4
resource "aws_s3_bucket_public_access_block" "public_bucket_4_pab" {
  bucket = aws_s3_bucket.public_bucket_4.id

  # These should be true for security, but are false for misconfig demo
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# MISCONFIGURATION: Overly permissive bucket policy allowing public access for bucket 4
resource "aws_s3_bucket_policy" "public_bucket_4_policy" {
  bucket = aws_s3_bucket.public_bucket_4.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket_4.arn}/*"
      },
      {
        Sid       = "PublicListBucket" 
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.public_bucket_4.arn
      }
    ]
  })
}

# MISCONFIGURED S3 Bucket 5 - Public Backups
resource "aws_s3_bucket" "public_bucket_5" {
  bucket = "public-backups-${random_id.multiple_buckets_suffix.hex}"
  
  # MISCONFIGURATION: Force destroy allows deletion even with objects
  force_destroy = true

  tags = {
    Name        = "Public Backups Bucket"
    Environment = "Demo"
    Purpose     = "Security Testing"
    BucketNumber = "5"
  }
}

# MISCONFIGURATION: Public read access to bucket 5
resource "aws_s3_bucket_public_access_block" "public_bucket_5_pab" {
  bucket = aws_s3_bucket.public_bucket_5.id

  # These should be true for security, but are false for misconfig demo
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# MISCONFIGURATION: Overly permissive bucket policy allowing public access for bucket 5
resource "aws_s3_bucket_policy" "public_bucket_5_policy" {
  bucket = aws_s3_bucket.public_bucket_5.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket_5.arn}/*"
      },
      {
        Sid       = "PublicListBucket" 
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = aws_s3_bucket.public_bucket_5.arn
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
resource "aws_s3_object" "sample_file_1" {
  bucket = aws_s3_bucket.public_bucket_1.id
  key    = "index.html"
  content = "<html><body><h1>Public Web Assets - Insecure Bucket 1</h1></body></html>"
  
  # MISCONFIGURATION: No server-side encryption for object
  content_type = "text/html"

  tags = {
    Purpose = "Demo Web Content"
  }
}

resource "aws_s3_object" "sample_file_2" {
  bucket = aws_s3_bucket.public_bucket_2.id
  key    = "download.txt"
  content = "This is a sample download file in an insecure bucket"
  
  # MISCONFIGURATION: No server-side encryption for object
  content_type = "text/plain"

  tags = {
    Purpose = "Demo Download"
  }
}

resource "aws_s3_object" "sample_file_3" {
  bucket = aws_s3_bucket.public_bucket_3.id
  key    = "media.txt"
  content = "Sample media file metadata in an insecure bucket"
  
  # MISCONFIGURATION: No server-side encryption for object
  content_type = "text/plain"

  tags = {
    Purpose = "Demo Media"
  }
}

resource "aws_s3_object" "sample_file_4" {
  bucket = aws_s3_bucket.public_bucket_4.id
  key    = "document.txt"
  content = "Sensitive document content that should not be public"
  
  # MISCONFIGURATION: No server-side encryption for object
  content_type = "text/plain"

  tags = {
    Purpose = "Demo Document"
  }
}

resource "aws_s3_object" "sample_file_5" {
  bucket = aws_s3_bucket.public_bucket_5.id
  key    = "backup.sql"
  content = "-- Database backup file with sensitive data\nCREATE TABLE users (id INT, password VARCHAR(255));"
  
  # MISCONFIGURATION: No server-side encryption for object
  content_type = "application/sql"

  tags = {
    Purpose = "Demo Backup"
  }
}

# Outputs for all 5 buckets
output "bucket_1_name" {
  description = "Name of the public web assets S3 bucket"
  value       = aws_s3_bucket.public_bucket_1.id
}

output "bucket_1_arn" {
  description = "ARN of the public web assets S3 bucket" 
  value       = aws_s3_bucket.public_bucket_1.arn
}

output "bucket_1_domain_name" {
  description = "Domain name of the public web assets S3 bucket"
  value       = aws_s3_bucket.public_bucket_1.bucket_domain_name
}

output "bucket_2_name" {
  description = "Name of the public downloads S3 bucket"
  value       = aws_s3_bucket.public_bucket_2.id
}

output "bucket_2_arn" {
  description = "ARN of the public downloads S3 bucket" 
  value       = aws_s3_bucket.public_bucket_2.arn
}

output "bucket_2_domain_name" {
  description = "Domain name of the public downloads S3 bucket"
  value       = aws_s3_bucket.public_bucket_2.bucket_domain_name
}

output "bucket_3_name" {
  description = "Name of the public media S3 bucket"
  value       = aws_s3_bucket.public_bucket_3.id
}

output "bucket_3_arn" {
  description = "ARN of the public media S3 bucket" 
  value       = aws_s3_bucket.public_bucket_3.arn
}

output "bucket_3_domain_name" {
  description = "Domain name of the public media S3 bucket"
  value       = aws_s3_bucket.public_bucket_3.bucket_domain_name
}

output "bucket_4_name" {
  description = "Name of the public documents S3 bucket"
  value       = aws_s3_bucket.public_bucket_4.id
}

output "bucket_4_arn" {
  description = "ARN of the public documents S3 bucket" 
  value       = aws_s3_bucket.public_bucket_4.arn
}

output "bucket_4_domain_name" {
  description = "Domain name of the public documents S3 bucket"
  value       = aws_s3_bucket.public_bucket_4.bucket_domain_name
}

output "bucket_5_name" {
  description = "Name of the public backups S3 bucket"
  value       = aws_s3_bucket.public_bucket_5.id
}

output "bucket_5_arn" {
  description = "ARN of the public backups S3 bucket" 
  value       = aws_s3_bucket.public_bucket_5.arn
}

output "bucket_5_domain_name" {
  description = "Domain name of the public backups S3 bucket"
  value       = aws_s3_bucket.public_bucket_5.bucket_domain_name
}

# Summary output
output "all_bucket_names" {
  description = "List of all public bucket names"
  value = [
    aws_s3_bucket.public_bucket_1.id,
    aws_s3_bucket.public_bucket_2.id,
    aws_s3_bucket.public_bucket_3.id,
    aws_s3_bucket.public_bucket_4.id,
    aws_s3_bucket.public_bucket_5.id
  ]
}