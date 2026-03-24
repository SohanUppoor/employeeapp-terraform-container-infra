# variable "aws_access_key" {}
# variable "aws_secret_key" {}
variable "environment" {
  default = "dev"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS"
  type        = string
}