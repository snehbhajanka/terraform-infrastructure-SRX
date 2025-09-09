# Misconfigured EC2 Instance - INTENTIONALLY INSECURE  
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
  region = "us-west-2"
}

# Get default VPC (MISCONFIGURATION: Using default VPC instead of custom VPC)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# MISCONFIGURATION: Overly permissive security group allowing all traffic
resource "aws_security_group" "insecure_sg" {
  name_prefix = "insecure-sg-"
  description = "Intentionally insecure security group for demo"
  vpc_id      = data.aws_vpc.default.id

  # MISCONFIGURATION: Allow all inbound traffic from anywhere
  ingress {
    description = "All traffic from anywhere"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MISCONFIGURATION: Allow SSH from anywhere
  ingress {
    description = "SSH from anywhere"  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MISCONFIGURATION: Allow RDP from anywhere
  ingress {
    description = "RDP from anywhere"
    from_port   = 3389
    to_port     = 3389  
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Insecure Security Group"
    Environment = "Demo"
    Purpose     = "Security Testing"
  }
}

# MISCONFIGURATION: Hardcoded SSH key pair (in real world, this would be generated)
resource "aws_key_pair" "insecure_key" {
  key_name   = "insecure-demo-key"
  # MISCONFIGURATION: This is a demo key, never use hardcoded keys in real scenarios
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7iOWyOJ... demo-key-not-for-production"

  tags = {
    Name    = "Demo Insecure Key"
    Purpose = "Security Testing"
  }
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# MISCONFIGURATION: EC2 instance with multiple security issues
resource "aws_instance" "insecure_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  key_name              = aws_key_pair.insecure_key.key_name
  vpc_security_group_ids = [aws_security_group.insecure_sg.id]
  
  # MISCONFIGURATION: Using default subnet instead of private subnet
  subnet_id = tolist(data.aws_subnets.default.ids)[0]
  
  # MISCONFIGURATION: Auto-assign public IP (should use NAT Gateway instead)
  associate_public_ip_address = true
  
  # MISCONFIGURATION: No IMDSv2 enforcement
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"  # Should be "required" for security
    http_put_response_hop_limit = 1
  }

  # MISCONFIGURATION: Unencrypted root EBS volume
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = false  # Should be true for security
    
    # MISCONFIGURATION: No KMS key specified
    # kms_key_id = "alias/aws/ebs"
    
    delete_on_termination = true

    tags = {
      Name = "Insecure Root Volume"
    }
  }

  # MISCONFIGURATION: Overly permissive IAM role (if attached)
  # iam_instance_profile = aws_iam_instance_profile.insecure_profile.name

  # MISCONFIGURATION: Insecure user data script
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              
              # MISCONFIGURATION: Weak file permissions
              echo "<h1>Insecure Web Server</h1>" > /var/www/html/index.html
              chmod 777 /var/www/html/index.html
              
              # MISCONFIGURATION: Running service as root
              systemctl start httpd
              systemctl enable httpd
              
              # MISCONFIGURATION: Storing secrets in user data
              export SECRET_KEY="hardcoded-secret-key-123"
              echo $SECRET_KEY > /tmp/secret.txt
              chmod 644 /tmp/secret.txt
              EOF
  )

  tags = {
    Name        = "Insecure EC2 Instance"
    Environment = "Demo" 
    Purpose     = "Security Testing"
    Owner       = "Demo User"
  }
}

# MISCONFIGURATION: Overly permissive IAM role
resource "aws_iam_role" "insecure_role" {
  name = "insecure-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "Insecure EC2 Role"
    Purpose = "Security Testing"
  }
}

# MISCONFIGURATION: Attach overly broad permissions
resource "aws_iam_role_policy" "insecure_policy" {
  name = "insecure-policy"
  role = aws_iam_role.insecure_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"  # MISCONFIGURATION: Allow all actions
        Resource = "*"  # MISCONFIGURATION: On all resources
      }
    ]
  })
}

resource "aws_iam_instance_profile" "insecure_profile" {
  name = "insecure-profile"
  role = aws_iam_role.insecure_role.name
}

# Outputs
output "instance_id" {
  description = "ID of the misconfigured EC2 instance"
  value       = aws_instance.insecure_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the misconfigured EC2 instance"
  value       = aws_instance.insecure_instance.public_ip
  sensitive   = false  # MISCONFIGURATION: Should be sensitive
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.insecure_instance.private_ip
}

output "security_group_id" {
  description = "ID of the insecure security group"
  value       = aws_security_group.insecure_sg.id
}