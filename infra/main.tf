terraform {
  required_version = ">= 1.5.0"

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

# -----------------------------
# Ubuntu 22.04 AMI (Dynamic)
# -----------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# -----------------------------
# SSH Key Pair (Public Key Only)
# -----------------------------
resource "aws_key_pair" "mongo_key" {
  key_name   = "mongo-k3s-key"
  public_key = file("~/.ssh/mongo-k3s-key.pub")
}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "k3s_sg" {
  name        = "k3s-security-group"
  description = "Security group for k3s + Mongo + Express"

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # tighten later
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Express
  ingress {
    description = "Express"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Mongo (Lab only)
  ingress {
    description = "MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k3s-sg"
  }
}

# -----------------------------
# EC2 Instance (Count = 1)
# -----------------------------
resource "aws_instance" "k3s_node" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.mongo_key.key_name

  vpc_security_group_ids = [
    aws_security_group.k3s_sg.id
  ]

  tags = {
    Name = "k3s-single-node"
  }
}