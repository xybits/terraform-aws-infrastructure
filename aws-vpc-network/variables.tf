
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
    default     = "vpc"
}

variable "cidr_block_base" {
    description = "X.Y.X part of VPC CIDR block (in the form of X.Y.Z.0/24)"
    type        = string
    default     = "10.11.0"
}

variable "multi_az_rds" {
    description = "Create RDS in multi-az?"
    type        = bool
    default     = false
}

variable "rds_port" {
    description = "RDS port"
    type        = number
    default     = 5432
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
    account_id = data.aws_caller_identity.caller.account_id
    region     = data.aws_region.current.name

    primary_az   = data.aws_availability_zones.az.names[0]
    secondary_az = data.aws_availability_zones.az.names[1]

    // vpc cidr block
    cidr_block_vpc     = "${var.cidr_block_base}.0/24"

    // small blocks (subnet mask = 28, addresses = 16)
    cidr_block_rds_primary      = cidrsubnet(local.cidr_block_vpc, 4, 0) //   0 -  15 / 28
    cidr_block_rds_secondary    = cidrsubnet(local.cidr_block_vpc, 4, 1) //  16 -  31 / 28

    // small blocks (subnet mask = 28, addresses = 16)
    cidr_block_small_primary    = cidrsubnet(local.cidr_block_vpc, 4, 2) //  32 -  47 / 28
    cidr_block_small_secondary  = cidrsubnet(local.cidr_block_vpc, 4, 3) //  48 -  63 / 28

    // medium blocks (subnet mask = 27, addresses = 32)
    cidr_block_medium_primary   = cidrsubnet(local.cidr_block_vpc, 3, 2) //  64 -  95 / 27
    cidr_block_medium_secondary = cidrsubnet(local.cidr_block_vpc, 3, 3) //  96 - 127 / 27

    // larger blocks (subnet mask = 26, addresses = 64)
    cidr_block_large_primary    = cidrsubnet(local.cidr_block_vpc, 2, 2) // 128 - 191 / 26
    cidr_block_large_secondary  = cidrsubnet(local.cidr_block_vpc, 2, 3) // 192 - 255 / 26
}
