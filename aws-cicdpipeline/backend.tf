terraform {
  backend "s3" {
    bucket         = "s3-terraform-tfstate3-file"
    key            = "terraform.tfstate-codepipeline"
    region         = "us-east-1"
    dynamodb_table = "dynamodb-tfstate-lockID2"
  }
}

# note name the lock-id like this LockID  the l in capital letter