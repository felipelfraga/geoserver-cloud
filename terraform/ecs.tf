# resource "aws_ecr_repository" "this" {
#   name                 = "geoserver-cloud-repository"
#   image_tag_mutability = "IMMUTABLE"
#   force_delete         = true

#   provisioner "local-exec" {
#     command     = "./ecr-push.sh"
#     interpreter = ["bash", "-c"]
#   }

# }

# resource "aws_ecr_repository_policy" "this" {
#   repository = aws_ecr_repository.this.name
#   policy     = <<EOF
#   {
#     "Version": "2008-10-17",
#     "Statement": [
#       {
#         "Sid": "full-access-to-geoserver-cloud-repository",
#         "Effect": "Allow",
#         "Principal": "*",
#         "Action": [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:BatchGetImage",
#           "ecr:CompleteLayerUpload",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:GetLifecyclePolicy",
#           "ecr:InitiateLayerUpload",
#           "ecr:PutImage",
#           "ecr:UploadLayerPart"
#         ]
#       }
#     ]
#   }
#   EOF
# }

# resource "aws_security_group" "geoserver" {
#   name   = "geoserver"
#   vpc_id = var.vpc_id

#   ingress {
#     protocol         = "tcp"
#     from_port        = 80
#     to_port          = 80
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     protocol         = "-1"
#     from_port        = 0
#     to_port          = 0
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_ecs_cluster" "this" {
#   name = "geoserver-cloud"
# }

# resource "aws_ecs_service" "this" {
#   name            = "geoserver-cloud"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.this.arn
#   launch_type     = "FARGATE"

#   network_configuration {
#     security_groups  = [aws_security_group.geoserver.id]
#     subnets          = [var.subnet_id]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = aws_alb_target_group.this.arn
#     container_name   = "geoserver-cloud"
#     container_port   = 80
#   }

#   desired_count = 1
# }


# resource "aws_ecs_task_definition" "this" {
#   family                   = "geoserver-cloud"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = "arn:aws:iam::293748214279:role/ecsTaskExecutionRole"
#   memory                   = 1024
#   cpu                      = 512
#   container_definitions = jsonencode([
#     {
#       name      = "geoserver-cloud"
#       image     = "293748214279.dkr.ecr.us-east-1.amazonaws.com/geoserver-cloud-repository:0.0.1-alpha"
#       memory    = 1024
#       cpu       = 512
#       essential = true
#       mountPoints = [
#           {
#               containerPath = "/shapefiles"
#               sourceVolume = "geoserver-store"
#           }
#       ]
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#         }
#       ]
#     }
#   ])

#   # volume {
#   #   name      = "service-storage"
#   #   host_path = "/ecs/service-storage"
#   # }

#   volume {
#     name      = "geoserver-store"
#     efs_volume_configuration {
#       file_system_id = aws_efs_file_system.this.id
#       root_directory = "/"
#     }
#   }

# }


