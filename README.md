
# aws-terraform-infrastructure

This project contains terraform modules to create AWS Infrastructure that includes VPC, Subnets, Security Groups,
RDS Server, Bastion Host, EC2 Instance and S3 Bucket.


## Prerequisites:

Download and install the following tools:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) version is 2.0+
- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install) where (0.12 <= version < 0.13)

## Preparation

Follow AWS CLI User Guide to install the tool and configure your aws profile.
Make sure to configure your default AWS profile to match the AWS Region,
you will later provide to run terraform modules.  

## Configuration

Change your directory to `./stack` and create a file named `us-east-2.tfvars`. This file is intended as
a supplier of variables required to run terraform against `us-east-2` AWS Region (Ohio).

This file will look something like the followings:

```text
# Provide one of the four supported AWS Regions: us-east-1, us-east-2, us-west-1, us-west-2
region  = "us-east-2"

project = "Some project name"
prefix  = "project_named_short_prefix"

# Provide unique values to the second and third octates when creating multiple stacks in the same AWS Region
#  i.e., 10.x.y; e.g.: 10.11.0, 10.11.1, 10.13.11, 10.17.123 etc...
cidr_block_base = "10.11.13"

# If S3 bukcet creation is enabled, provide an existing IAM ARN
#  which should be allowed read/write access to the bucket
s3_enabled       = true
s3_iam_principal = "arn:aws:iam::${aws_user_id}:user/${iam_name}"

# If bastion host creation is enabled, provide name to the ssh public key (already uploaded) in the AWS Region
bastion_enabled = true
ssh_key_bastion = "ssh-key-pub-ec2-bastion-instance"

# Provide name to the ssh public key (already uploaded) in the AWS Region
# Preferred: use different public key than that is used in bastion host
ssh_key_app     = "ssh-key-pub-ec2-app-instances"
```

## Running the code

It never hurts to initialize the terraform project every time, prior to running other terraform commands.
It is especially useful to run this command when new terraform modules are (de-)referenced.

```bash
# Initialize project with changes in modules etc.
# Creates ".terraform/" folder in this location
terraform init

# Display execution plan
terraform plan -var-file="us-east-2.tfvars"

# Apply changes (using the variable file created above in the "Configuration" section)
# Updates (Creates, if do not already exist) two files:
# |  +-- terraform.tfstate
# |  +-- terraform.tfstate.backup
# NOTE: DO NOT DELETE THESE FILES
#     They hold infrastructure states of the resources terraform is managing. 
terraform apply -var-file="us-east-2.tfvars"

# Destroy resources
# Updates two files:
# |  +-- terraform.tfstate
# |  +-- terraform.tfstate.backup
terraform destroy -var-file="us-east-2.tfvars"

# Help
terraform help
```
