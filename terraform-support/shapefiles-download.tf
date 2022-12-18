# resource "random_pet" "shapefiles_download_bucket_name" {
#   prefix = "shapefiles-download"
#   length = 4
# }

# resource "aws_s3_bucket" "shapefiles_download" {
#   bucket        = random_pet.shapefiles_download_bucket_name.id
#   force_destroy = true
# }

# resource "aws_s3_bucket_acl" "shapefiles_download" {
#   bucket = aws_s3_bucket.shapefiles_download.id
#   acl    = "private"
# }

# data "archive_file" "shapefiles_download" {
#   type = "zip"

#   source_dir  = "${path.module}/shapefiles-download"
#   output_path = "${path.module}/build/shp-download.zip"
# }

# resource "aws_s3_object" "shapefiles_download" {
#   bucket = aws_s3_bucket.shapefiles_download.id

#   key    = "shapefiles_download.zip"
#   source = data.archive_file.shapefiles_download.output_path

#   etag = filemd5(data.archive_file.shapefiles_download.output_path)
# }

#stuck
resource "aws_security_group" "shapefiles_download" {
  name   = "geoserver"
  vpc_id = var.vpc_id

  # ingress {
  #   protocol         = "tcp"
  #   from_port        = 80
  #   to_port          = 80
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# resource "aws_lambda_function" "shapefiles_download" {
#   function_name = "shapefiles_download"

#   s3_bucket = aws_s3_bucket.shapefiles_download.id
#   s3_key    = aws_s3_object.shapefiles_download.key

#   runtime = "nodejs12.x"
#   handler = "shapefiles-download.handler"

#   source_code_hash = data.archive_file.shapefiles_download.output_base64sha256

#   role = aws_iam_role.shapefiles_download_lambda_exec.arn

#   file_system_config {
#     arn              = aws_efs_access_point.shapefiles_download.arn
#     local_mount_path = "/mnt/shapefiles"
#   }

#   vpc_config {
#     subnet_ids         = [var.subnet_id]
#     security_group_ids = [aws_security_group.shapefiles_download.id]
#   }

#   depends_on = [aws_efs_mount_target.this]

# }

# resource "aws_cloudwatch_log_group" "shapefiles_download" {
#   name = "/aws/lambda/${aws_lambda_function.shapefiles_download.function_name}"

#   retention_in_days = 1
# }

# resource "aws_iam_role" "shapefiles_download_lambda_exec" {
#   name = "serverless_lambda"



#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Sid    = ""
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
#     role       = aws_iam_role.shapefiles_download_lambda_exec.name
#     policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
# }

# resource "aws_iam_role_policy_attachment" "shapefiles_download_lambda_policy" {
#   role       = aws_iam_role.shapefiles_download_lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# resource "aws_efs_access_point" "shapefiles_download" {
#   file_system_id = aws_efs_file_system.this.id

#   posix_user {
#     gid = 1000
#     uid = 1000
#   }

#   root_directory {
#     path = "/shapefiles"
#     creation_info {
#       owner_gid   = 1000
#       owner_uid   = 1000
#       permissions = "0777"
#     }
#   }
# }
