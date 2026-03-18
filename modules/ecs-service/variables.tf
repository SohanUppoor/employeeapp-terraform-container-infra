variable "cluster_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "frontend_image" {
  type = string
}

variable "backend_image" {
  type = string
}

variable "frontend_target_group" {
  type = string
}

variable "backend_target_group" {
  type = string
}

variable "ecs_task_execution_role" {
  type = string
}

variable "db_url" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}