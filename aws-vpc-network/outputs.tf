
############################################################################
#
#  Availability Zone
#
############################################################################

output "primary_az" {
    value = local.primary_az
}

output "secondary_az" {
    value = local.secondary_az
}

############################################################################
#
#  Subnet CIDR Block
#
############################################################################

output "cidr_block_vpc" {
    value = local.cidr_block_vpc
}

output "cidr_block_public_primary" {
    value = local.cidr_block_small_primary
}

output "cidr_block_public_secondary" {
    value = local.cidr_block_small_secondary
}

output "cidr_block_rds_primary" {
    value = local.cidr_block_rds_primary
}

output "cidr_block_rds_secondary" {
    value = local.cidr_block_rds_secondary
}

output "cidr_block_medium_primary" {
    value = local.cidr_block_medium_primary
}

output "cidr_block_medium_secondary" {
    value = local.cidr_block_medium_secondary
}

output "cidr_block_large_primary" {
    value = local.cidr_block_large_primary
}

output "cidr_block_large_secondary" {
    value = local.cidr_block_large_secondary
}

############################################################################
#
#  Subnet
#
############################################################################

output "subnet_public_primary" {
    value = aws_subnet.public_primary.id
}

output "subnet_public_secondary" {
    value = aws_subnet.public_secondary.id
}

output "subnet_rds_primary" {
    value = aws_subnet.rds_primary.id
}

output "subnet_rds_secondary" {
    value = aws_subnet.rds_secondary.id
}

output "subnet_group_rds" {
    value = aws_db_subnet_group.rds.name
}

output "subnet_medium_primary" {
    value = aws_subnet.private_medium_primary.id
}

output "subnet_medium_secondary" {
    value = aws_subnet.private_medium_secondary.id
}

output "subnet_large_primary" {
    value = aws_subnet.private_large_primary.id
}

output "subnet_large_secondary" {
    value = aws_subnet.private_large_secondary.id
}

############################################################################
#
#  VPC and Gateway
#
############################################################################

output "nat_gw" {
    value = aws_eip.nat.public_ip
}

output "vpc_id" {
    value = aws_vpc.main.id
}

############################################################################
#
#  Security Group
#
############################################################################

output "security_group_default" {
    value = aws_vpc.main.default_security_group_id
}

output "security_group_rds" {
    value = aws_security_group.rds.id
}

output "security_group_bastion" {
    value = aws_security_group.bastion.id
}

output "security_group_elb" {
    value = aws_security_group.elb.id
}

output "security_group_apps" {
    value = aws_security_group.apps.id
}
