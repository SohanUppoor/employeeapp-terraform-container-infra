module "network" {
  source          = "./modules/network"
  name            = "employeeapp"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
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

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  # ec2_instance_id    = module.ec2.ec2_id
  certificate_arn = var.certificate_arn
}

module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  db_sg_id           = module.security.rds_sg_id
  db_password        = var.db_password
}

module "ecr" {
  source = "./modules/ecr"

  frontend_repo_name = "employee-frontend"
  backend_repo_name  = "employee-backend"
}

module "iam" {
  source = "./modules/iam"
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  cluster_name = "employee-app-cluster"
}

module "ecs_service" {
  source = "./modules/ecs-service"

  cluster_id     = module.ecs_cluster.cluster_id
  public_subnets = module.network.public_subnet_ids
  ecs_sg_id      = module.security.ecs_sg_id

  frontend_image = "${module.ecr.frontend_repository_url}:latest"
  backend_image  = "${module.ecr.backend_repository_url}:latest"

  frontend_target_group = module.alb.frontend_target_group_arn
  backend_target_group  = module.alb.backend_target_group_arn

  ecs_task_execution_role = module.iam.ecs_task_execution_role_arn

  db_url      = module.rds.db_endpoint
  db_username = "admin"
  db_password = var.db_password
}