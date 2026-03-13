resource "aws_ecr_repository" "frontend" {
  name = var.frontend_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "employee-frontend-repo"
  }
}

resource "aws_ecr_repository" "backend" {
  name = var.backend_repo_name

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "employee-backend-repo"
  }
}