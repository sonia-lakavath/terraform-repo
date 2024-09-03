provider "aws" {
  region = var.region
  access_key  = "AKIAQMEY6KXERNU4LC64"
  secret_key  = "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"
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main_vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

# Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "route_table"
  }
}

# Default Route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Route Table Association
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}

# EC2 Instance
resource "aws_instance" "web_instance" {
  ami           = "ami-0a91cd140a1fc148a"  # Amazon Linux 2 AMI (ap-south-1)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.web_sg.name]

  # Replace with your GitHub raw URL
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git
              git clone https://github.com/sonia-lakavath/terraform-repo.git /home/ec2-user/web-server-setup
              chmod +x /home/ec2-user/web-server-setup/setup.sh
              /home/ec2-user/web-server-setup/setup.sh
              EOF

  tags = {
    Name = "WebServer"
  }
}
