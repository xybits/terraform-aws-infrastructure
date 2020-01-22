
############################################################################
#
#  RDS Security Group
#
############################################################################

resource "aws_security_group" "rds" {
    description = "RDS Security Group"
    name        = "${var.prefix}-security-rds-${var.suffix}"

    vpc_id = aws_vpc.main.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port       = var.rds_port
        to_port         = var.rds_port
        protocol        = "tcp"
        security_groups = [
            aws_security_group.bastion.id,
            aws_security_group.apps.id
        ]
    }

    tags = {
        Name    = "${var.prefix}-security-rds-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  Bastion Security Group
#
############################################################################

resource "aws_security_group" "bastion" {
    description = "Bastion Security Group"
    name        = "${var.prefix}-security-bastion-${var.suffix}"

    vpc_id = aws_vpc.main.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = [local.cidr_block_vpc]
    }

    tags = {
        Name    = "${var.prefix}-security-bastion-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  Elastic Load Balancer Security Group
#
############################################################################

resource "aws_security_group" "elb" {
    description = "Elastic Load Balancer Security Group"
    name        = "${var.prefix}-security-elb-${var.suffix}"

    vpc_id = aws_vpc.main.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = var.elb_port
        to_port     = var.elb_port
        protocol    = var.elb_protocol
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name    = "${var.prefix}-security-elb-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  Application Security Group
#
############################################################################

resource "aws_security_group" "apps" {
    description = "App Security Group"
    name        = "${var.prefix}-security-apps-${var.suffix}"

    vpc_id = aws_vpc.main.id

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        security_groups = [aws_security_group.bastion.id]
    }

    ingress {
        from_port = var.app_port
        to_port   = var.app_port
        protocol  = var.app_protocol
        security_groups = [aws_security_group.elb.id]
    }

    ingress {
        from_port = -1
        to_port   = -1
        protocol  = "icmp"
        cidr_blocks = [local.cidr_block_vpc]
    }

    tags = {
        Name    = "${var.prefix}-security-app-${var.suffix}"
        Project = var.project
    }
}
