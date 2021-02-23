
variable "region" {
    description = "AWS Region"
    type        = string
}

variable "project" {
    description = "Project"
    type        = string
}

variable "prefix" {
    description = "Resource name prefix"
    type        = string
}

variable "suffix" {
    description = "Resource name suffix"
    type        = string
    default     = "postgres"
}

variable "instance_class" {
    description = "The RDS instance class"
    type        = string
    default     = "db.t2.small"
}

variable "subnet_group_name" {
    description = "VPC subnet group name"
    type        = string
}

variable "security_group_id" {
    description = "VPC security group id"
    type        = string
}

variable "engine" {
    description = "Engine type"
    type        = string
    default     = "postgres"
}

variable "engine_version" {
    description = "Engine version"
    type        = string
    default     = "11.5"
}

variable "storage" {
    description = "Storage size in GB"
    type        = number
    default     = 32
}

variable "storage_type" {
    description = "Storage type"
    type        = string
    default     = "gp2"
}

variable "db_name" {
    description = "The database name"
    type        = string
    default     = "postgres"
}

variable "port" {
    description = "The database port"
    type        = number
    default     = 5432
}

variable "username" {
    description = "The database username"
    type        = string
    default     = "postgres"
}

variable "password" {
    description = "The database password"
    type        = string
}

variable "backup_retention_period" {
    description = "Database backup retention period"
    type        = number
    default     = 3
}

variable "backup_window" {
    description = "Preferred database backup window"
    type        = string
    default     = "03:00-03:45"
}

variable "maintenance_window" {
    description = "Preferred database maintenance window"
    type        = string
    default     = "mon:04:30-mon:05:15"
}

variable "multi_az" {
    description = "Deploy RDS in multi-az environment?"
    type        = bool
    default     = true
}

variable "enable" {
    description = "Instantiate RDS instance"
    type        = bool
    default     = false
}
