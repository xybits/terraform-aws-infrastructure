
############################################################################
#
#  RDS Instance
#
############################################################################

resource "aws_db_instance" "rds" {
    count                   = var.enable ? 1 : 0

    instance_class          = var.instance_class
    allocated_storage       = var.storage
    storage_type            = var.storage_type
    storage_encrypted       = true
    multi_az                = var.multi_az

    engine                  = var.engine
    engine_version          = var.engine_version

    identifier              = local.identifier
    name                    = var.db_name
    port                    = var.port
    username                = var.username
    password                = var.password

    backup_retention_period = var.backup_retention_period
    backup_window           = var.backup_window
    maintenance_window      = var.maintenance_window
    skip_final_snapshot     = true

    db_subnet_group_name    = var.subnet_group_name
    vpc_security_group_ids  = [var.security_group_id]

    allow_major_version_upgrade = false
    auto_minor_version_upgrade  = false

    tags = {
        Name            = "${var.prefix}-rds-${var.suffix}"
        Project         = var.project
        workload-type   = "other"
    }
}
