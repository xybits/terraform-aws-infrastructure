
############################################################################
#
#  S3 resources
#
############################################################################

resource "aws_s3_bucket" "main" {
    count         = var.enable ? 1 : 0

    bucket        = local.bucket
    force_destroy = true

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = local.sse_algorithm
            }
        }
    }

    cors_rule {
        allowed_headers = ["*"]
        allowed_origins = ["*"]
        allowed_methods = ["GET", "PUT", "POST", "DELETE"]
        expose_headers = ["ETag"]
        max_age_seconds = 3600
    }

    versioning {
        enabled = var.versioning
    }

    tags = {
        Name    = local.bucket
        Project = var.project
    }
}

resource "aws_s3_bucket_policy" "main" {
    count  = var.enable ? 1 : 0

    bucket = aws_s3_bucket.main[count.index].id
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [{
        "Action": [
            "s3:GetObjectAcl",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:GetObject",
            "s3:PutObjectAcl",
            "s3:ListMultipartUploadParts",
            "s3:PutObject"
        ],
        "Effect": "Allow",
        "Principal": { "AWS": "${var.iam_principal}" },
        "Resource": ["${aws_s3_bucket.main[count.index].arn}/*"]
    }, {
        "Action": [
            "s3:ListBucketMultipartUploads",
            "s3:GetBucketLocation"
        ],
        "Effect": "Allow",
        "Principal": { "AWS": "${var.iam_principal}" },
        "Resource": ["${aws_s3_bucket.main[count.index].arn}"]
    }]
}
POLICY
}
