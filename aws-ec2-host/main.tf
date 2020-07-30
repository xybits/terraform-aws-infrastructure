
############################################################################
#
#  EC2 Instance
#
############################################################################

resource "aws_instance" "ec2" {
    count  = var.instance_count

    ami           = var.aws_ami
    instance_type = var.instance_type

    disable_api_termination              = false
    instance_initiated_shutdown_behavior = "stop"

    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = [var.security_group_id]
    associate_public_ip_address = var.associate_public_ip

    key_name   = var.ssh_key

    monitoring = false
    user_data  = file("${path.module}/user-data.sh")

    lifecycle {
        ignore_changes = [ami]
    }

    root_block_device {
        volume_type           = "gp2"
        volume_size           = 8
        delete_on_termination = true
    }

    tags = {
        Name    = "${var.prefix}-ec2-${var.suffix}-${count.index}"
        Project = var.project
    }
}

############################################################################
#
#  EBS Volume Mount
#
############################################################################

resource "aws_ebs_volume" "data" {
    count = var.enable_data_disk_mount ? var.instance_count : 0

    availability_zone = aws_instance.ec2[count.index].availability_zone
    encrypted         = true
    type              = "gp2"
    size              = var.data_disk_size

    tags = {
        Name    = "${var.prefix}-ebs-${var.suffix}-${count.index}"
        Project = var.project
    }
}

resource "aws_volume_attachment" "data" {
    count = var.enable_data_disk_mount ? var.instance_count : 0

    device_name  = "/dev/sdk"
    force_detach = true

    instance_id = aws_instance.ec2[count.index].id
    volume_id   = aws_ebs_volume.data[count.index].id
}
