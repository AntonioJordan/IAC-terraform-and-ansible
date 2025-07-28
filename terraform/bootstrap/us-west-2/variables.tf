variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "bucket_name" {
  description = "Unique name for the S3 bucket to store Terraform state"
  type        = string
  default     = "toni-bootstrap-tfstate-us-west-2"
}

variable "dynamodb_table" {
  description = "Name for the DynamoDB table used for Terraform state locking"
  type        = string
  default     = "toni-tfstate-lock-table"
}
