
############################################################################
#
#  VPC
#
############################################################################

resource "aws_vpc" "main" {
    cidr_block = local.cidr_block_vpc

    instance_tenancy = "default"

    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name    = "${var.prefix}-main-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  DHCP Options
#
############################################################################

resource "aws_vpc_dhcp_options" "vpc" {
    domain_name         = "${local.region}.compute.internal"
    domain_name_servers = ["AmazonProvidedDNS"]

    tags = {
        Name    = "${var.prefix}-dhcp-options-${var.suffix}"
        Project = var.project
    }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id          = aws_vpc.main.id
    dhcp_options_id = aws_vpc_dhcp_options.vpc.id
}
