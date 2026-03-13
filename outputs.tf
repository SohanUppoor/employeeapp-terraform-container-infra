output "frontend_ecr_repo_url" {
  value = module.ecr.frontend_repository_url
}

output "backend_ecr_repo_url" {
  value = module.ecr.backend_repository_url
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnet_ids
}

output "private_subnets" {
  value = module.network.private_subnet_ids
}

# output "ec2_public_ip" {
#   value = module.ec2.ec2_public_ip
# }

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}
