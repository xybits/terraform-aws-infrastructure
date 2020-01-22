
output "instance_id" {
    value = var.enable ? join("", aws_db_instance.rds.*.id) : ""
}

output "endpoint" {
    value = var.enable ? join("", aws_db_instance.rds.*.endpoint) : ""
}

output "address" {
    value = var.enable ? join("", aws_db_instance.rds.*.address) : ""
}

output "port" {
    value = var.enable ? join("", aws_db_instance.rds.*.port) : ""
}
