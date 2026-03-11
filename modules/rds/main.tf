resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "employee-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "employee-db-subnet-group"
  }
}

resource "aws_db_instance" "employee_db" {
  identifier              = "employee-data"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  publicly_accessible     = false
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [var.db_sg_id]

  tags = {
    Name = "employee-db"
  }
}