terraform {
  backend "s3" {
    bucket = "filuet-armenia-terraform"
    key    = "filuet-prod/vpc.tfstate"
    region = "eu-central-1"
    encrypt = true
    #dynamodb_table = "your-dynamodb-lock-table"  # Optional: DynamoDB table name for state locking
  }
}
