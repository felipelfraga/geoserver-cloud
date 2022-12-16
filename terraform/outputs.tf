output "shapefiles_download_bucket_name" {
  value = aws_s3_bucket.shapefiles_download.id
}

output "shapefiles_download_function_arn" {
  value = aws_lambda_function.shapefiles_download.arn
}
