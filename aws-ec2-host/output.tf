
output "instance_ids" {
    value = var.instance_count > 0 ? join(",", aws_instance.ec2.*.id) : ""
}

output "public_ips" {
    value = var.instance_count > 0 ? join(",", aws_instance.ec2.*.public_ip) : ""
}

output "private_ips" {
    value = var.instance_count > 0 ? join(",", aws_instance.ec2.*.private_ip) : ""
}
