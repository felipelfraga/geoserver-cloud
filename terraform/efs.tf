resource "aws_efs_file_system" "this" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "false"
}

resource "aws_security_group" "efs" {
  name        = "efs"
  description = "Permite acesso ao mount target"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }
}

resource "aws_efs_mount_target" "this" {
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.efs.id]
}
