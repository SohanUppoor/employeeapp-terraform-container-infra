# Backend Task Definition
resource "aws_ecs_task_definition" "backend" {
  family                   = "employee-backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_execution_role

  container_definitions = jsonencode([
    {
      name  = "employee-backend"
      image = var.backend_image
      portMappings = [
        {
          containerPort = 8081
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "DB_URL", value = var.db_url },
        { name = "DB_USERNAME", value = var.db_username },
        { name = "DB_PASSWORD", value = var.db_password }
      ]
    }
  ])
}


# Frontend Task Definition
resource "aws_ecs_task_definition" "frontend" {
  family                   = "employee-frontend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_execution_role

  container_definitions = jsonencode([
    {
      name  = "employee-frontend"
      image = var.frontend_image
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}


# Backend ECS Service
resource "aws_ecs_service" "backend" {
  name            = "employee-backend-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.backend.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.backend_target_group
    container_name   = "employee-backend"
    container_port   = 8081
  }

  depends_on = [var.backend_target_group]
}


# Frontend ECS Service
resource "aws_ecs_service" "frontend" {
  name            = "employee-frontend-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.frontend.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.frontend_target_group
    container_name   = "employee-frontend"
    container_port   = 80
  }

  depends_on = [var.frontend_target_group]
}