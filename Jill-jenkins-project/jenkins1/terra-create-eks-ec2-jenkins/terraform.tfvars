# terraform.tfvars
vpc_cidr_block    = "10.0.0.0/16" # VPC address
subnet_cidr_block = "10.0.1.0/20" # subnet address
availability_zone = "ap-south-1a" # availability zone (change it according to your AWS region)
env_prefix        = "dev"         # prefix for tags
instance_type     = "t2.medium"    # EC2 instance type