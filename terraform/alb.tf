resource "aws_lb" "this" {
  name               = "geoserver"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.geoserver.id]
  subnets            = [var.subnet_id, var.subnet2_id]
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "this" {
  name        = "geoserver"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
   healthy_threshold   = "4"
   interval            = "20"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "2"
   path                = "/"
   unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_lb.this.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.this.id
    type             = "forward"
  }
}
