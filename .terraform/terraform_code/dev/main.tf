
#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for Amazon Linux AMI
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source to retrieve the default VPC id
data "aws_vpc" "default" {
  default = true
}

# Define tags locally and naming prefix
locals {
  default_tags = {
    "env" = var.env
  }
  prefix = var.prefix
  name_prefix = "${local.prefix}-${var.env}"
}


# ECR Repository for mysql
resource "aws_ecr_repository" "mysql" {
  name = "my-mysql-repo"
  force_delete = true
  tags = merge(local.default_tags, { "Name" = "my-mysql-repo" })
}

# ECR Repository for webapp
resource "aws_ecr_repository" "webapp" {
  name = "my-webapp-repo"
  force_delete = true
  tags = merge(local.default_tags, { "Name" = "my-webapp-repo" })
}

# Retrieve IAM Instance Profile
data "aws_iam_instance_profile" "ec2_profile" {
  name = "LabInstanceProfile"
}

# EC2 Instance
resource "aws_instance" "my_amazon" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"  # or use a variable if needed
  key_name                    = aws_key_pair.my_key.key_name
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  associate_public_ip_address = false

  iam_instance_profile = data.aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -a -G docker ec2-user
  EOF

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags, { "Name" = "webapp-instance" })
}

# Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = "assignment-dev"
  public_key = file("~/.ssh/assignment-dev.pub")
}

# Security Group
resource "aws_security_group" "my_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id
  
  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTP on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTP on port 8081"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP on port 8082"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  
  ingress {
    description = "HTTP on port 8083"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, { "Name" = "${local.name_prefix}-sg" })
}

# Elastic IP
resource "aws_eip" "static_eip" {
  instance = aws_instance.my_amazon.id
  tags = merge(local.default_tags, { "Name" = "${local.name_prefix}-eip" })
}
