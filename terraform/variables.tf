variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0230bd60aa48260c6"  # Amazon Linux 2
}

variable "alert_email" {
  description = "Email for budget alerts"
  type        = string
}

variable "dockerhub_username" {
  description = "DockerHub username"
  type        = string
}