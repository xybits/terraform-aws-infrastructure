
data "aws_region" "current" {
}

data "aws_availability_zones" "az" {
    state = "available"
}

data "aws_caller_identity" "caller" {
}
