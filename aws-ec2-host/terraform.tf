
############################################################################
#
#  Terraform and Provider constraints
#
############################################################################

terraform {
    required_version = ">= 0.12, < 0.13"
}

provider "aws" {
    version = "~> 2.0"
    region  = var.region
}
