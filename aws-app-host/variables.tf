
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
    default     = "app"
}

variable "aws_ami" {
    description = "AMI to use"
    type        = string
}

variable "instance_type" {
    description = "The type of instance to start"
    type        = string
    default     = "t2.micro"
}

variable "subnet_id" {
    description = "VPC subnet id"
    type        = string
}

variable "security_group_id" {
    description = "VPC security group id"
    type        = string
}

variable "ssh_key" {
    description = "The key name of the Key Pair to use for the instance"
    type        = string
}

variable "volume_size" {
    description = "The size of the root volume in gigabytes"
    type        = string
    default     = 8
}

variable "enable_data_disk_mount" {
    description = "Enable data volume mount"
    type        = bool
    default     = true
}

variable "data_disk_size" {
    description = "The size of the data volume in gigabytes"
    type        = string
    default     = 32
}

variable "data_disk_az" {
    description = "Data volume creation availability zone"
    type        = string
    default     = ""
}

