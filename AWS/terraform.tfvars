# VPC variables

# Specify the region where resources will be created
aws_region = "eu-west-1"

# Specify the CIDR block for the VPC
vpc_cidr_block = "10.0.0.0/16"

# Specify the number of public subnets
public_subnet_count = 1

# Specify the number of private subnets
private_subnet_count = 2

# Specify the list of CIDR masks for public subnets
public_subnet_masks = [24]

# Specify the list of CIDR masks for private subnets
private_subnet_masks = [24]

# Specify the name for the VPC
vpc_name = "custom-vpc"

# Specify tags for the VPC
vpc_tags = {
  Environment = "test"
  Owner       = "hetmansky"
}

# Specify tags for the subnets
subnet_tags = {
  Environment = "test"
  Owner       = "hetmansky"
}

# EC2 variables

# Instance type for the EC2 instances
instance_type = "t3.micro"

# SSH key name for EC2 instances
key_name = "your-ssh-key"

# Desired capacity for the Auto Scaling group
desired_capacity = 1

# Minimum size for the Auto Scaling group
min_size = 1

# Maximum size for the Auto Scaling group
max_size = 3

# EBS volume size in GiB
ebs_volume_size = 8

# Instance name for the EC2 instances
instance_name = "ec2-instance"

# Tags for the EC2 instances
instance_tags = {
  Environment = "test"
  Owner       = "hetmansky"
}

# Security Group variables

# Security group name for EC2 instances
ec2_sg_name = "ec2-sg"

# Security group tags for EC2 instances
ec2_sg_tags = {
  Environment = "test"
  Owner       = "hetmansky"
}

# RDS security group name
rds_sg_name = "rds-sg"

# RDS security group tags
rds_sg_tags = {
  Environment = "test"
  Owner       = "hetmansky"
}

# AMI variables

# Specify the name filter for the AMI
ami_name = "ubuntu/images/hvm-ssd/ubuntu-20.04-amd64-server-*"

# Specify the owners for the AMI
ami_owners = ["099720109477"]

# RDS variables

# Database name for the RDS instance (using only lowercase alphanumeric characters and hyphens)
db_name = "wordpress-db"

# Database username for the RDS instance
db_username = "admin"

# Database password for the RDS instance
db_password = "securepassword"

# Tags for the RDS instance
db_tags = {
  Environment = "test"
  Owner       = "hetmansky"
}
