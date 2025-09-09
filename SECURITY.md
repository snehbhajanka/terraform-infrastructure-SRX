# Security Configuration Guide

## S3 Bucket Security

This document explains the security configurations applied to S3 buckets in this Terraform repository.

### Public Access Block Configuration

All S3 buckets in this repository are configured with `aws_s3_bucket_public_access_block` to prevent accidental public exposure:

```hcl
resource "aws_s3_bucket_public_access_block" "bucket_name_pab" {
  bucket = aws_s3_bucket.bucket_name.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

#### Security Setting Explanations

- **`block_public_acls = true`**: Prevents new public ACLs from being applied to the bucket and objects
- **`block_public_policy = true`**: Prevents new public bucket policies from being applied  
- **`ignore_public_acls = true`**: Causes Amazon S3 to ignore all public ACLs on buckets and objects
- **`restrict_public_buckets = true`**: Restricts access to buckets with public policies to only AWS service principals and authorized users

### Bucket Policy Security

Bucket policies are configured to restrict access to the AWS account owner only:

```hcl
resource "aws_s3_bucket_policy" "secure_bucket_policy" {
  bucket = aws_s3_bucket.bucket_name.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RestrictedAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.bucket_name.arn,
          "${aws_s3_bucket.bucket_name.arn}/*"
        ]
      }
    ]
  })
}
```

### Security Best Practices Applied

1. **No Public Access**: All public access is blocked through multiple layers of protection
2. **Account-Level Restriction**: Access is restricted to the AWS account owner only
3. **Principle of Least Privilege**: Only necessary permissions (GetObject, ListBucket) are granted
4. **Defense in Depth**: Multiple security controls work together (public access block + restrictive policy)

### Compliance Standards

These configurations help meet various compliance requirements:

- **CIS AWS Foundations Benchmark**: Controls related to S3 bucket security
- **AWS Well-Architected Framework**: Security pillar best practices
- **NIST Cybersecurity Framework**: Access control and data protection
- **SOC 2**: Security and availability controls

### Validation

To verify the security configuration:

```bash
# Validate Terraform configuration
terraform validate

# Review the security settings in the plan
terraform plan | grep -A 10 -B 10 "public_access_block\|bucket_policy"
```

### References

- [AWS S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)
- [S3 Bucket Policy Examples](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-policy-examples.html)
- [Terraform AWS S3 Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [CIS AWS Foundations Benchmark](https://docs.cisecurity.org/en-us/benchmarks/browse/aws)