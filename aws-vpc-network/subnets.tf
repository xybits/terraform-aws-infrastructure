
############################################################################
#
#  Private RDS Subnets
#
############################################################################

resource "aws_subnet" "rds_primary" {
    vpc_id     = aws_vpc.main.id
    cidr_block = local.cidr_block_rds_primary

    availability_zone = local.primary_az

    tags = {
        Name       = "${var.prefix}-subnet-rds-primary-${var.suffix}"
        Project    = var.project
        Visibility = "Private"
    }
}

resource "aws_subnet" "rds_secondary" {
    vpc_id     = aws_vpc.main.id
    cidr_block = local.cidr_block_rds_secondary

    availability_zone = local.secondary_az

    tags = {
        Name       = "${var.prefix}-subnet-rds-secondary-${var.suffix}"
        Project    = var.project
        Visibility = "Private"
    }
}

resource "aws_db_subnet_group" "rds" {
    description = "Database subnet security group"
    name        = "${var.prefix}-subnet-group-rds-${var.suffix}"

    subnet_ids = [
        aws_subnet.rds_primary.id,
        aws_subnet.rds_secondary.id
    ]

    tags = {
        Name       = "${var.prefix}-subnet-group-rds-${var.suffix}"
        Project    = var.project
        Visibility = "Private"
    }
}

############################################################################
#
#  Public Subnets
#
############################################################################

resource "aws_subnet" "public_primary" {
    vpc_id     = aws_vpc.main.id
    cidr_block = local.cidr_block_small_primary

    availability_zone = local.primary_az

    tags = {
        Name       = "${var.prefix}-subnet-public-primary-${var.suffix}"
        Project    = var.project
        Visibility = "Public"
    }
}

resource "aws_subnet" "public_secondary" {
    vpc_id     = aws_vpc.main.id
    cidr_block = local.cidr_block_small_secondary

    availability_zone = local.secondary_az

    tags = {
        Name       = "${var.prefix}-subnet-public-secondary-${var.suffix}"
        Project    = var.project
        Visibility = "Public"
    }
}

############################################################################
#
#  Private Subnets
#
############################################################################

resource "aws_subnet" "private_medium_primary" {
    vpc_id     = aws_vpc.main.id
    cidr_block = local.cidr_block_medium_primary

    availability_zone = local.primary_az

    tags = {
        Name       = "${var.prefix}-subnet-medium-primary-${var.suffix}"
        Project    = var.project
        Visibility = "Private"
    }
}

resource "aws_subnet" "private_medium_secondary" {
    vpc_id     = aws_vpc.main.id
    cidr_block = local.cidr_block_medium_secondary

    availability_zone = local.secondary_az

    tags = {
        Name       = "${var.prefix}-subnet-medium-secondary-${var.suffix}"
        Project    = var.project
        Visibility = "Private"
    }
}

resource "aws_subnet" "private_large_primary" {
    vpc_id     = aws_vpc.main.id
    cidr_block = local.cidr_block_large_primary

    availability_zone = local.primary_az

    tags = {
        Name       = "${var.prefix}-subnet-large-primary-${var.suffix}"
        Project    = var.project
        Visibility = "Private"
    }
}

resource "aws_subnet" "private_large_secondary" {
    vpc_id     = aws_vpc.main.id
    cidr_block = local.cidr_block_large_secondary

    availability_zone = local.secondary_az

    tags = {
        Name       = "${var.prefix}-subnet-large-secondary-${var.suffix}"
        Project    = var.project
        Visibility = "Private"
    }
}

############################################################################
#
#  Network ACLs
#
############################################################################

resource "aws_network_acl" "main" {
    vpc_id     = aws_vpc.main.id

    subnet_ids = [
        aws_subnet.rds_primary.id,
        aws_subnet.rds_secondary.id,
        aws_subnet.public_primary.id,
        aws_subnet.public_secondary.id,
        aws_subnet.private_medium_primary.id,
        aws_subnet.private_medium_secondary.id,
        aws_subnet.private_large_primary.id,
        aws_subnet.private_large_secondary.id
    ]

    egress {
        action     = "allow"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        rule_no    = 100
        cidr_block = "0.0.0.0/0"
    }

    ingress {
        action     = "allow"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        rule_no    = 100
        cidr_block = "0.0.0.0/0"
    }

    tags = {
        Name    = "${var.prefix}-network-acl-${var.suffix}"
        Project = var.project
    }
}
