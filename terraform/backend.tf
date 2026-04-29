

terraform {
  backend "s3" {
    bucket         = "8byte-ai-assignment-bucket-aswin"
    key            = "network/terraform.tfstate" 
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"     
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}