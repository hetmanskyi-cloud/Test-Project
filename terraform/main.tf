locals {
  common_tags = {
    Environment = "test"
  }
}

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

# Network ACL
# Module to create Network ACL
module "nacl" {
  source             = "./modules/nacl"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
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

# AMI
# Module to find the latest Ubuntu AMI
module "ami" {
  source = "./modules/ami"

  ami_name   = var.ami_name   # Pass the ami_name variable
  ami_owners = var.ami_owners # Pass the ami_owners variable
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

# IAM
# Module to create IAM resources
module "iam" {
  source = "./modules/iam"
}

# Define the subnet group for RDS
resource "aws_db_subnet_group" "default" {
  name        = "default-subnet-group"
  description = "Default subnet group for RDS instances"
  subnet_ids  = module.vpc.private_subnet_ids # Include only private subnets
  tags = {
    Name = "default-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage                   = 20                                          # Specify allocated storage size
  storage_type                        = "gp2"                                       # Specify storage type
  engine                              = "mysql"                                     # Specify database engine
  engine_version                      = "5.7"                                       # Specify engine version
  instance_class                      = "db.t2.micro"                               # Specify instance class
  identifier                          = var.db_name                                 # Specify database identifier
  username                            = var.db_username                             # Specify database username
  password                            = var.db_password                             # Specify database password
  db_subnet_group_name                = aws_db_subnet_group.default.name            # Specify subnet group name
  skip_final_snapshot                 = true                                        # Skip final snapshot upon deletion
  publicly_accessible                 = false                                       # Avoid public access
  backup_retention_period             = 30                                          # Set backup retention period
  multi_az                            = true                                        # Enable multi-AZ for high availability
  storage_encrypted                   = true                                        # Enable storage encryption
  deletion_protection                 = true                                        # Enable deletion protection
  iam_database_authentication_enabled = true                                        # Enable IAM authentication
  performance_insights_enabled        = true                                        # Enable Performance Insights
  performance_insights_kms_key_id     = module.iam.rds_performance_insights_key_arn # Use the KMS key from IAM module

  # Enable enhanced monitoring
  monitoring_interval = 60                                 # Interval in seconds
  monitoring_role_arn = module.iam.rds_monitoring_role_arn # Use the IAM role from IAM module

  # Enable automatic minor upgrades
  auto_minor_version_upgrade = true

  # Enable necessary logs
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"] # Enable logs

  # Copy tags to snapshot
  copy_tags_to_snapshot = true # Ensure tags are copied to snapshots

  # VPC configuration
  vpc_security_group_ids = [var.security_group_id] # Specify VPC security group IDs
  tags                   = local.common_tags       # Specify tags
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

  # KMS Key ARN for Performance Insights
  performance_insights_kms_key_arn = module.iam.rds_performance_insights_key_arn

  # IAM Role ARN for RDS monitoring
  monitoring_role_arn = module.iam.rds_monitoring_role_arn
}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-security-group"
  }
}
