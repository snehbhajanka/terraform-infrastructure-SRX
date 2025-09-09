# terraform-infrastructure-SRX

This repository contains sample Terraform configurations for AWS infrastructure with intentional security misconfigurations for demonstration and testing purposes.

## ⚠️ WARNING ⚠️
**These Terraform files contain intentional security vulnerabilities and misconfigurations. DO NOT use them in production environments.**

## Security Updates

### S3 Bucket Security Configuration

The S3 bucket in this repository has been secured with the following configurations:

#### Public Access Block
All S3 buckets now include an `aws_s3_bucket_public_access_block` resource with all security settings enabled:
- `block_public_acls = true` - Blocks public ACLs
- `block_public_policy = true` - Blocks public bucket policies  
- `ignore_public_acls = true` - Ignores all public ACLs
- `restrict_public_buckets = true` - Restricts public bucket policies

#### Bucket Policy Restrictions
Bucket policies have been updated to remove public access (`Principal: "*"`) and instead only allow access from the AWS account owner.

These configurations follow AWS security best practices as outlined in the [AWS S3 Block Public Access Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html).

## Files

### `s3-misconfigured.tf`
Sample Terraform configuration creating an AWS S3 bucket with security fixes applied:
- ✅ **Public access blocked** - All public access settings set to true
- ✅ **Secure bucket policy** - Restricts access to account owner only
- ❌ No server-side encryption (still misconfigured for demo)
- ❌ No versioning enabled (still misconfigured for demo)
- ❌ No access logging (still misconfigured for demo)
- ❌ No lifecycle management (still misconfigured for demo)

### `ec2-misconfigured.tf`  
Sample Terraform configuration creating an AWS EC2 instance with multiple security misconfigurations:
- Overly permissive security group (0.0.0.0/0 access)
- Unencrypted EBS volumes
- Public IP assignment in default VPC
- IMDSv1 enabled
- Hardcoded secrets in user data
- Overly broad IAM permissions
- Weak file permissions

## Purpose
These files are intended for:
- Security testing and scanning tool validation
- Educational purposes to demonstrate common Terraform security anti-patterns  
- Infrastructure security training
- DevSecOps pipeline testing

## Usage
```bash
# Initialize Terraform (not recommended for production)
terraform init

# Plan the deployment (review the insecure configurations)
terraform plan

# Apply (only in isolated test environments)
terraform apply
```

**Remember to clean up resources after testing:**
```bash
terraform destroy
```

## Security References
- [AWS S3 Block Public Access Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)
- [Terraform AWS Provider: aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)
- [CIS AWS Foundations Benchmark](https://docs.cisecurity.org/en-us/benchmarks/browse/aws)