provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "C:/Users/matthias/.aws/credentials"
  profile                 = "tfinfrauser"
}

# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage" {
  bucket = "mm-terraform-remote-state-storage"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name        = "S3 Remote Terraform State Store"
    responsible = "Matthias Malzahn"
    mm_belong   = "terraformBackend"
    terraform   = "true"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "mm-terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "DynamoDB Terraform State Lock Table"
    responsible = "Matthias Malzahn"
    mm_belong   = "terraformBackend"
    terraform   = "true"
  }
}
