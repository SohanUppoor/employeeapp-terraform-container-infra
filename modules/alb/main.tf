resource "aws_lb" "app_alb" {
  name               = "employee-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "employee-app-alb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "employee-app-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/employees"
    port = "8081"
  }
}

# no need of this because of ASG attachment of ec2
# resource "aws_lb_target_group_attachment" "app_attachment" {
#   target_group_arn = aws_lb_target_group.app_tg.arn
#   target_id        = var.ec2_instance_id
#   port             = 80
# }

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}