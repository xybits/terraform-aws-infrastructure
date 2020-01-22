
############################################################################
#
#  Internet Gateway
#
############################################################################

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name    = "${var.prefix}-igw-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  Internet Gateway Route Table
#
############################################################################

resource "aws_route_table" "igw_primary" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name    = "${var.prefix}-route-table-igw-primary-${var.suffix}"
        Project = var.project
    }
}

resource "aws_route_table" "igw_secondary" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name    = "${var.prefix}-route-table-igw-secondary-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  Interget Gateway Route Table Associations
#
############################################################################

resource "aws_route_table_association" "igw_primary" {
    route_table_id = aws_route_table.igw_primary.id
    subnet_id      = aws_subnet.public_primary.id
}

resource "aws_route_table_association" "igw_secondary" {
    route_table_id = aws_route_table.igw_secondary.id
    subnet_id      = aws_subnet.public_secondary.id
}

############################################################################
#
#  NAT Gateway
#    Food for thought: https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-comparison.html
#
############################################################################

resource "aws_eip" "nat" {
    vpc = true

    tags = {
        Name    = "${var.prefix}-nat-${var.suffix}"
        Project = var.project
    }
}

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_primary.id

    tags = {
        Name    = "${var.prefix}-natgw-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  NAT Gateway Route Table
#
############################################################################

resource "aws_route_table" "natgw" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw.id
    }

    tags = {
        Name    = "${var.prefix}-route-table-natgw-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  NAT Gateway Route Table Associations
#
############################################################################

resource "aws_route_table_association" "natgw_rds_primary" {
    route_table_id = aws_route_table.natgw.id
    subnet_id      = aws_subnet.rds_primary.id
}

resource "aws_route_table_association" "natgw_rds_secondary" {
    route_table_id = aws_route_table.natgw.id
    subnet_id      = aws_subnet.rds_secondary.id
}

resource "aws_route_table_association" "natgw_medium_primary" {
    route_table_id = aws_route_table.natgw.id
    subnet_id      = aws_subnet.private_medium_primary.id
}

resource "aws_route_table_association" "natgw_medium_secondary" {
    route_table_id = aws_route_table.natgw.id
    subnet_id      = aws_subnet.private_medium_secondary.id
}

resource "aws_route_table_association" "natgw_large_primary" {
    route_table_id = aws_route_table.natgw.id
    subnet_id      = aws_subnet.private_large_primary.id
}

resource "aws_route_table_association" "natgw_large_secondary" {
    route_table_id = aws_route_table.natgw.id
    subnet_id      = aws_subnet.private_large_secondary.id
}
