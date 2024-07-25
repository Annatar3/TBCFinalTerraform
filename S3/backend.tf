terraform {
  backend "s3" {
    bucket = "filuettfstatefiles"
    key    = "s3/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    #dynamodb_table = "your-dynamodb-lock-table"  # Optional: DynamoDB table name for state locking
  }
}
