
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

variable "rds_instance_class" {
    description = "RDS instance class"
    type        = string
    default     = "db.t2.medium"
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

variable "rds_multi_az" {
    description = "Deploy RDS in multi-az environment?"
    type        = bool
    default     = false
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

variable "app_instance_ami" {
    description = "Application hosts instance ami"
    type        = string
    default     = ""
}

variable "app_instance_type" {
    description = "Application hosts instance type"
    type        = string
    default     = "t2.medium"
}

variable "app_instance_count" {
    description = "Number of application hosts"
    type        = number
    default     = 1
}

variable "app_enable_disk_mount" {
    description = "Enable data volume mount to application hosts"
    type        = bool
    default     = false
}

variable "app_ssh_key" {
    description = "The key name of the Key Pair to use for the app hosts"
    type        = string
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

variable "bastion_instance_ami" {
    description = "Bastion hosts instance ami"
    type        = string
    default     = ""
}

variable "bastion_instance_type" {
    description = "Bastion hosts instance type"
    type        = string
    default     = "t2.micro"
}

variable "bastion_instance_count" {
    description = "Number of bastion hosts"
    type        = number
    default     = 0
}

variable "bastion_enable_disk_mount" {
    description = "Enable data volume mount to bastion hosts"
    type        = bool
    default     = false
}

variable "bastion_ssh_key" {
    description = "The key name of the Key Pair to use for the bastion hosts"
    type        = string
    default     = ""
}

locals {
    amazon_linux_2 = {
        "us-east-1" = "ami-00068cd7555f543d5"
        "us-east-2" = "ami-0dacb0c129b49f529"
        "us-west-1" = "ami-0b2d8d1abb76a53d8"
        "us-west-2" = "ami-0c5204531f799e0c6"
    }
    centos7 = {
        "us-east-1" = "ami-0affd4508a5d2481b"
        "us-east-2" = "ami-01e36b7901e884a10"
        "us-west-1" = "ami-098f55b4287a885ba"
        "us-west-2" = "ami-0bc06212a56393ee1"
    }

    app_instance_ami = var.app_instance_ami != "" ? var.app_instance_ami : lookup(local.centos7, var.region)
    bastion_instance_ami = var.bastion_instance_ami != "" ? var.bastion_instance_ami : lookup(local.amazon_linux_2, var.region)
}

module "vpc" {
    source = "../aws-vpc-network"
    region = var.region

    project = var.project
    prefix  = var.prefix

    cidr_block_base = var.cidr_block_base

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

    instance_class = var.rds_instance_class
    password       = var.rds_password
    multi_az       = var.rds_multi_az

    enable = var.rds_enabled
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

module "apps" {
    source = "../aws-ec2-host"
    region = var.region

    project = var.project
    prefix  = var.prefix
    suffix  = "app"

    subnet_id           = module.vpc.subnet_large_primary
    security_group_id   = module.vpc.security_group_apps
    associate_public_ip = false

    aws_ami       = local.app_instance_ami
    instance_type = var.app_instance_type
    ssh_key       = var.app_ssh_key

    instance_count         = var.app_instance_count
    enable_data_disk_mount = var.app_enable_disk_mount
}

module "bastion" {
    source = "../aws-ec2-host"
    region = var.region

    project = var.project
    prefix  = var.prefix
    suffix  = "bastion"

    subnet_id           = module.vpc.subnet_public_primary
    security_group_id   = module.vpc.security_group_bastion
    associate_public_ip = true

    aws_ami       = local.bastion_instance_ami
    instance_type = var.bastion_instance_type
    ssh_key       = var.bastion_ssh_key

    instance_count         = var.bastion_instance_count
    enable_data_disk_mount = var.bastion_enable_disk_mount
}
