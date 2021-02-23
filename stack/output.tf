
############################################################################
#
#  VPC: Availability Zone
#
############################################################################

output "vpc_primary_az" {
    value = module.vpc.primary_az
}

output "vpc_secondary_az" {
    value = module.vpc.secondary_az
}

############################################################################
#
#  VPC: Subnet CIDR Block
#
############################################################################

output "vpc_cidr_block_vpc" {
    value = module.vpc.cidr_block_vpc
}

output "vpc_cidr_block_public_primary" {
    value = module.vpc.cidr_block_public_primary
}

output "vpc_cidr_block_public_secondary" {
    value = module.vpc.cidr_block_public_secondary
}

output "vpc_cidr_block_rds_primary" {
    value = module.vpc.cidr_block_rds_primary
}

output "vpc_cidr_block_rds_secondary" {
    value = module.vpc.cidr_block_rds_secondary
}

output "vpc_cidr_block_medium_primary" {
    value = module.vpc.cidr_block_medium_primary
}

output "vpc_cidr_block_medium_secondary" {
    value = module.vpc.cidr_block_medium_secondary
}

output "vpc_cidr_block_large_primary" {
    value = module.vpc.cidr_block_large_primary
}

output "vpc_cidr_block_large_secondary" {
    value = module.vpc.cidr_block_large_secondary
}

############################################################################
#
#  VPC: Gateways
#
############################################################################

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "vpc_nat_gw" {
    value = module.vpc.nat_gw
}

############################################################################
#
#  S3 Bucket: Instance
#
############################################################################

output "s3_bucket_arn" {
    value = module.s3.s3_bucket_arn
}

output "s3_bucket_endpoint" {
    value = module.s3.s3_bucket_endpoint
}

############################################################################
#
#  RDS: Instance
#
############################################################################

output "rds_endpoint" {
    value = module.rds.endpoint
}

############################################################################
#
#  BASTION: Instances
#
############################################################################

output "bastion_public_ips" {
    value = module.bastion.public_ips
}

output "bastion_private_ips" {
    value = module.bastion.private_ips
}

############################################################################
#
#  APPS: Instances
#
############################################################################

output "apps_private_ips" {
    value = module.apps.private_ips
}
