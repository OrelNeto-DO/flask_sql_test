terraform {
  backend "s3" {
    bucket         = "devops1114bucket"  # שם ה-Bucket שלך
    key            = "gifapp.tfstate"   # נתיב ה-state בתוך ה-Bucket
    region         = var.aws_region      # האזור בו נמצא ה-Bucket
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "flask-app-vpc"
    AutoDestroy = "true"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name        = "flask-app-subnet"
    AutoDestroy = "true"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "flask-app-igw"
    AutoDestroy = "true"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "flask-app-rt"
    AutoDestroy = "true"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "app" {
  name        = "flask-app-sg"
  description = "Security group for Flask application"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5005
    to_port     = 5005
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "flask-app-sg"
    AutoDestroy = "true"
  }
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              EOF

  tags = {
    Name        = "flask-app-server"
    AutoStop    = "true"
    AutoDestroy = "true"
  }
}
