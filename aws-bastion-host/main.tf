
############################################################################
#
#  EC2 Instance
#
############################################################################

resource "aws_instance" "ec2" {
    count         = var.enable ? 1 : 0

    ami           = var.aws_ami
    instance_type = var.instance_type

    subnet_id              = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]

    associate_public_ip_address          = true
    disable_api_termination              = false
    instance_initiated_shutdown_behavior = "stop"

    key_name   = var.ssh_key

    monitoring = false
    user_data  = file("${path.module}/user-data.sh")

    lifecycle {
        ignore_changes = [ami]
    }

    tags = {
        Name    = "${var.prefix}-ec2-${var.suffix}"
        Project = var.project
    }
}
