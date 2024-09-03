terraform {
  backend "s3" {
    bucket         = "my-aws-terraform-first"  # Replace with your bucket name
    key            = "terraform/state.tfstate"
    region         = "ap-south-1"            
    encrypt        = true
  }
}
