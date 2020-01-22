
variable "region" {
    description = "AWS Region"
    type        = string
}

variable "project" {
    description = "Project"
    type        = string
}

variable "prefix" {
    description = "Resource name prefix"
    type        = string
}

variable "suffix" {
    description = "Resource name suffix"
    type        = string
    default     = "bucket"
}

variable "versioning" {
    description = "Enable versioning of S3 Bucket?"
    type        = bool
    default     = false
}

variable "iam_principal" {
    description = "The Principal entity that is allowed or denied access to the S3 Bucket"
    type        = string
}

variable "enable" {
    description = "Instance S3 bucket"
    type        = bool
    default     = false
}

locals {
    bucket        = "${var.prefix}-s3-${var.suffix}"
    sse_algorithm = "AES256"
}
