terraform {
  backend "s3" {
    bucket = "devops1114bucket"
    key    = "gifapp.tfstate"
    region = "us-east-1"
  }
}
