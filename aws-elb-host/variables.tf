
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
    default     = "loadbalancer"
}

variable "subnet_id" {
    description = "VPC subnet id"
    type        = string
}

variable "security_group_id" {
    description = "VPC security group id"
    type        = string
}

variable "elb_port" {
    description = "ELB Port"
    type        = number
    default     = 80
}

variable "app_port" {
    description = "Application port"
    type        = number
    default     = 8080
}
