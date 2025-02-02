provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "flask-app-vpc"
    AutoDestroy = "true"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "flask-app-subnet"
    AutoDestroy = "true"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "flask-app-igw"
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
    Name = "flask-app-rt"
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

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH Access
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP Access
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTPS Access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-app-sg"
    AutoDestroy = "true"
  }
}

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type         = "t2.micro"
  subnet_id             = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update and install dependencies
              yum update -y
              yum install -y docker git
              service docker start
              usermod -a -G docker ec2-user

              # Install docker-compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Clone the repository
              cd /home/ec2-user
              git clone https://github.com/OrelNeto-DO/flask_sql_test.git app
              cd app

              # Set permissions
              chmod 755 /usr/local/bin/docker-compose
              chown -R ec2-user:ec2-user /home/ec2-user/app

              # Build and run with docker-compose
              /usr/local/bin/docker-compose up -d

              # Enable docker to start on boot
              systemctl enable docker
              EOF

  tags = {
    Name = "flask-app-server"
    AutoStop = "true"
    AutoDestroy = "true"
  }
}