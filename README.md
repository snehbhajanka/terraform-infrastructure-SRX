# terraform-infrastructure-SRX

This repository contains sample Terraform configurations for AWS infrastructure with intentional security misconfigurations for demonstration and testing purposes.

## ⚠️ WARNING ⚠️
**These Terraform files contain intentional security vulnerabilities and misconfigurations. DO NOT use them in production environments.**

## Files

### `s3-misconfigured.tf`
Sample Terraform configuration creating an AWS S3 bucket with multiple security misconfigurations:
- Public read access enabled
- No server-side encryption
- No versioning enabled  
- No access logging
- Overly permissive bucket policy
- No lifecycle management

### `s3-multiple-buckets.tf`
Sample Terraform configuration creating 5 AWS S3 buckets with multiple security misconfigurations:
- Public read access enabled for all buckets
- No server-side encryption
- No versioning enabled
- No access logging
- Overly permissive bucket policies
- No lifecycle management
- Sample objects with sensitive content exposed publicly

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