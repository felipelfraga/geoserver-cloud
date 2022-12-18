resource "aws_security_group" "geoserver_load_balancer" {
  name   = "geoserver-load-balancer"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb" "this" {
  name                       = "geoserver"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.geoserver_load_balancer.id]
  subnets                    = [var.subnet_id, var.subnet2_id]
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "this" {
  name        = "geoserver"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"


  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    protocol            = "HTTP"
    timeout             = "10"
    unhealthy_threshold = "6"
    path                = "/geoserver/ows?service=WMS&version=1.3.0&request=GetCapabilities"
    matcher             = "200"
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
