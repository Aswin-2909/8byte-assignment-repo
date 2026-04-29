

# 1. S3 Bucket for Terraform State
resource "aws_s3_bucket" "state_bucket" {
  bucket = "8byte-ai-assignment-bucket-aswin"

  lifecycle {
    prevent_destroy = true
  }
}

# 2. Enable Versioning
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. DynamoDB Table for State Locking
resource "aws_dynamodb_table" "state_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}