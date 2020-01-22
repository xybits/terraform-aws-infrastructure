
############################################################################
#
#  EC2 Instance
#
############################################################################

resource "aws_instance" "ec2" {
    ami           = var.aws_ami
    instance_type = var.instance_type

    disable_api_termination              = false
    instance_initiated_shutdown_behavior = "stop"

    subnet_id              = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]

    key_name   = var.ssh_key
    monitoring = false

    lifecycle {
        ignore_changes = [ami]
    }

    tags = {
        Name    = "${var.prefix}-ec2-${var.suffix}"
        Project = var.project
    }
}

############################################################################
#
#  EBS Volume Mount
#
############################################################################

resource "aws_ebs_volume" "data" {
    count = var.enable_data_disk_mount ? 1 : 0

    availability_zone = var.data_disk_az

    encrypted = true
    type      = "gp2"
    size      = var.data_disk_size

    tags = {
        Name    = "${var.prefix}-ebs-${var.suffix}"
        Project = var.project
    }
}

resource "aws_volume_attachment" "data" {
    count = var.enable_data_disk_mount ? 1 : 0

    device_name  = "/dev/sdk"
    force_detach = true

    instance_id = aws_instance.ec2.id
    volume_id   = aws_ebs_volume.data[count.index].id
}
