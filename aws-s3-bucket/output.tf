
output "s3_bucket_arn" {
    value = var.enable ? join("", aws_s3_bucket.main.*.arn) : ""
}

output "s3_bucket_endpoint" {
    value = var.enable ? join("", aws_s3_bucket.main.*.website_endpoint) : ""
}
