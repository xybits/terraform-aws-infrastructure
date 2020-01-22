
############################################################################
#
#  ELB Instance
#
############################################################################

resource "aws_elb" "main" {
    name = "${var.prefix}-elb-${var.suffix}"

    subnets         = [var.subnet_id]
    security_groups = [var.security_group_id]

    cross_zone_load_balancing   = true
    connection_draining         = true
    connection_draining_timeout = 300

    # allow port 80 through
    listener {
        instance_port     = var.app_port
        instance_protocol = "HTTP"
        lb_port           = var.elb_port
        lb_protocol       = "HTTP"
    }

    idle_timeout = 60

    health_check {
        target              = "HTTP:${var.app_port}/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 10
        unhealthy_threshold = 2
    }

    tags = {
        Name    = "${var.prefix}-elb-${var.suffix}"
        Project = var.project
        Scheme  = "internet-facing"
    }
}
