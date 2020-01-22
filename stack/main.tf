
terraform {
    required_version = ">= 0.12, < 0.13"
}

provider "aws" {
    version = "~> 2.0"
    region  = var.region
}

variable "region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-2"
}

variable "project" {
    description = "Project"
    type        = string
}

variable "prefix" {
    description = "Resource name prefix"
    type        = string
}

variable "cidr_block_base" {
    description = "X.Y.X part of VPC CIDR block (in the form of X.Y.Z.0/24)"
    type        = string
    default     = "10.11.0"
}

variable "s3_enabled" {
    description = "Enable S3 bucket creation"
    type        = bool
    default     = false
}

variable "s3_iam_principal" {
    description = "The Principal entity that is allowed or denied access to the S3 Bucket"
    type        = string
    default     = ""
}

variable "rds_enabled" {
    description = "Enable RDS instance creation"
    type        = bool
    default     = false
}

variable "rds_password" {
    description = "Password for RDS instance"
    type        = string
    default     = ""
}

variable "bastion_enabled" {
    description = "Enable bastion host creation"
    type        = bool
    default     = false
}

variable "ssh_key_bastion" {
    description = "The key name of the Key Pair to use for the bastion host"
    type        = string
    default     = ""
}

variable "ssh_key_app" {
    description = "The key name of the Key Pair to use for the app host"
    type        = string
}

variable "elb_port" {
    description = "ELB port"
    type        = number
    default     = 80
}

variable "elb_protocol" {
    description = "ELB protocol"
    type        = string
    default     = "tcp"
}

variable "app_port" {
    description = "Application port"
    type        = number
    default     = 8080
}

variable "app_protocol" {
    description = "Application protocol"
    type        = string
    default     = "tcp"
}

locals {
    amis = {
        "us-east-1" = "ami-00068cd7555f543d5"
        "us-east-2" = "ami-0dacb0c129b49f529"
        "us-west-1" = "ami-0b2d8d1abb76a53d8"
        "us-west-2" = "ami-0c5204531f799e0c6"
    }
    aws_ami = lookup(local.amis, var.region)

    instance_types = {
        bastion = "t2.micro"
        app     = "t2.small"
        rds     = "db.t2.small"
    }
}

module "vpc" {
    source = "../aws-vpc-network"
    region = var.region

    project = var.project
    prefix  = var.prefix

    cidr_block_base = "10.11.3"

    app_port = var.app_port
    elb_port = var.elb_port
}

module "s3" {
    source   = "../aws-s3-bucket"
    region   = var.region

    project = var.project
    prefix  = var.prefix

    iam_principal = var.s3_iam_principal
    enable        = var.s3_enabled
}

module "rds" {
    source = "../aws-rds-host"
    region = var.region

    project = var.project
    prefix  = var.prefix

    subnet_group_name = module.vpc.subnet_group_rds
    security_group_id = module.vpc.security_group_rds

    instance_class = lookup(local.instance_types, "rds")
    password       = var.rds_password
    multi_az       = false

    enable = var.rds_enabled
}

module "bastion" {
    source = "../aws-bastion-host"
    region = var.region

    project = var.project
    prefix  = var.prefix

    subnet_id         = module.vpc.subnet_public_secondary
    security_group_id = module.vpc.security_group_bastion

    aws_ami       = local.aws_ami
    instance_type = lookup(local.instance_types, "bastion")
    ssh_key       = var.ssh_key_bastion

    enable = var.bastion_enabled
}

module "elb" {
    source = "../aws-elb-host"
    region = var.region

    project = var.project
    prefix  = var.prefix

    subnet_id         = module.vpc.subnet_public_primary
    security_group_id = module.vpc.security_group_elb

    app_port = var.app_port
    elb_port = var.elb_port
}

module "web" {
    source = "../aws-app-host"
    region = var.region

    project = var.project
    prefix  = var.prefix

    subnet_id         = module.vpc.subnet_large_primary
    security_group_id = module.vpc.security_group_apps

    aws_ami       = local.aws_ami
    instance_type = lookup(local.instance_types, "app")
    ssh_key       = var.ssh_key_app
}
