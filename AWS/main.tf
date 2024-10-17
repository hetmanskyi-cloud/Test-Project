# VPC
# Module to create VPC and its components
module "vpc" {
  source = "./modules/vpc"

  # CIDR block for the VPC
  vpc_cidr_block = var.vpc_cidr_block

  # Number of public subnets
  public_subnet_count = var.public_subnet_count

  # Number of private subnets
  private_subnet_count = var.private_subnet_count

  # CIDR masks for public subnets
  public_subnet_masks = var.public_subnet_masks

  # CIDR masks for private subnets
  private_subnet_masks = var.private_subnet_masks

  # Name for the VPC
  vpc_name = var.vpc_name

  # Tags for the VPC
  vpc_tags = var.vpc_tags

  # Tags for the subnets
  subnet_tags = var.subnet_tags
}

# AMI
# Module to find the latest Ubuntu AMI
module "ami" {
  source = "./modules/ami"
}

# Security Groups
# Module to create Security Groups
module "security_groups" {
  source = "./modules/security_groups"

  # Name of the EC2 security group
  ec2_sg_name = var.ec2_sg_name

  # VPC ID where the Security Group will be created
  vpc_id = module.vpc.vpc_id

  # Tags for the EC2 security group
  ec2_sg_tags = var.ec2_sg_tags

  # Name of the RDS security group
  rds_sg_name = var.rds_sg_name

  # Tags for the RDS security group
  rds_sg_tags = var.rds_sg_tags
}

# EC2
# Module to create EC2 instances
module "ec2" {
  source = "./modules/ec2"

  # AMI ID for the EC2 instances
  ami_id = module.ami.ami_id

  # Instance type for the EC2 instances
  instance_type = var.instance_type

  # SSH key name for EC2 instances
  key_name = var.key_name

  # VPC ID where the EC2 instances will be created
  vpc_id = module.vpc.vpc_id

  # List of subnet IDs for the EC2 instances (public and private subnets)
  subnet_ids = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)

  # Desired capacity for the Auto Scaling group
  desired_capacity = var.desired_capacity

  # Minimum size for the Auto Scaling group
  min_size = var.min_size

  # Maximum size for the Auto Scaling group
  max_size = var.max_size

  # EBS volume size for the root volume
  ebs_volume_size = var.ebs_volume_size

  # Instance name for the EC2 instances
  instance_name = var.instance_name

  # Tags for the EC2 instances
  instance_tags = var.instance_tags

  # Security Group ID for the EC2 instances
  security_group_id = module.security_groups.ec2_sg_id
}

# RDS
# Module to create RDS instance
module "rds" {
  source = "./modules/rds"

  # Database name for the RDS instance
  db_name = var.db_name

  # Database username for the RDS instance
  db_username = var.db_username

  # Database password for the RDS instance
  db_password = var.db_password

  # Tags for the RDS instance
  db_tags = var.db_tags

  # IDs of private subnets where the RDS instance will be created
  private_subnet_ids = module.vpc.private_subnet_ids

  # VPC ID for the RDS instance
  vpc_id = module.vpc.vpc_id

  # Security Group ID for the RDS instance
  security_group_id = module.security_groups.ec2_sg_id
}
