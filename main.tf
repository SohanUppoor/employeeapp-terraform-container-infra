module "network" {
  source         = "./modules/network"
  name           = "employeeapp"
  vpc_cidr       = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets= ["10.0.11.0/24", "10.0.12.0/24"]
  azs            = ["us-east-1a", "us-east-1b"]
}

module "security" {
  source = "./modules/security"

  vpc_id = module.network.vpc_id
}

#not needed as we create it in asg
# module "ec2" {
#   source = "./modules/ec2"

#   subnet_id  = module.network.public_subnet_ids[0]
#   ec2_sg_id  = module.security.ec2_sg_id
# }

module "alb" {
  source = "./modules/alb"

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  alb_sg_id          = module.security.alb_sg_id
  # ec2_instance_id    = module.ec2.ec2_id
}

module "asg" {
  source = "./modules/asg"

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  target_group_arn   = module.alb.target_group_arn
  instance_type      = "t3.micro"
  security_group_id  = module.security.ec2_sg_id
  key_name           = "employeeapp-key"
  artifact_bucket_name = module.artifacts.artifact_bucket_name
  instance_profile_name = module.iam.instance_profile_name
  db_url      = "${module.rds.db_endpoint}"
  db_username = "admin"
  db_password = var.db_password
}

module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  db_sg_id            = module.security.rds_sg_id
  db_password         = var.db_password
}

module "artifacts" {
  source      = "./modules/s3-artifacts"
  bucket_name = "employeeapp-artifacts-${random_id.bucket_id.hex}"

}
module "iam" {
  source = "./modules/iam"
}

resource "random_id" "bucket_id" {
  byte_length = 4
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

output "artifact_bucket_name" {
  value = module.artifacts.artifact_bucket_name
}

