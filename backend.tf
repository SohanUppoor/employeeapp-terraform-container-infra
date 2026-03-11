terraform {

  backend "s3" {
    bucket         = "terraform-employee-state"  # your S3 bucket name
    key            = "employeeapp/terraform.tfstate" # path inside the bucket
    region         = "us-east-1"                   # your region
    dynamodb_table = "terraform-lock"            # DynamoDB table for locking
    encrypt        = true                          # encrypt state at rest
  }
}