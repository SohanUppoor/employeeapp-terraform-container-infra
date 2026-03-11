variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "db_sg_id" {}

variable "db_name" {
  default = "employeeapp"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  sensitive = true
}