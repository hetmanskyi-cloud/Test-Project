# VPC
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  public_subnet_masks  = var.public_subnet_masks
  private_subnet_masks = var.private_subnet_masks
  vpc_name             = var.vpc_name
  vpc_tags             = var.vpc_tags
  subnet_tags          = var.subnet_tags
}

# Network ACL
module "nacl" {
  source             = "./modules/nacl"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.security_groups.ec2_sg_id
  rds_sg_id          = module.security_groups.rds_sg_id
}

# Security Groups
module "security_groups" {
  source      = "./modules/security_groups"
  ec2_sg_name = var.ec2_sg_name
  ec2_sg_tags = var.ec2_sg_tags
  rds_sg_name = var.rds_sg_name
  rds_sg_tags = var.rds_sg_tags
  vpc_id      = module.vpc.vpc_id
}

# AMI
module "ami" {
  source     = "./modules/ami"
  ami_name   = var.ami_name
  ami_owners = var.ami_owners
}

# EC2
module "ec2" {
  source                = "./modules/ec2"
  ami_id                = module.ami.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_ids            = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  desired_capacity      = var.desired_capacity
  min_size              = var.min_size
  max_size              = var.max_size
  ebs_volume_size       = var.ebs_volume_size
  instance_name         = var.instance_name
  instance_tags         = var.instance_tags
  security_group_id     = module.security_groups.ec2_sg_id # Теперь это корректный выход
  vpc_id                = module.vpc.vpc_id
  instance_profile_name = var.instance_profile_name
}

# IAM
module "iam" {
  source = "./modules/iam"
}

# Define the subnet group for RDS
resource "aws_db_subnet_group" "default" {
  name        = "default-subnet-group"
  description = "Default subnet group for RDS instances"
  subnet_ids  = module.vpc.private_subnet_ids
  tags = {
    Name = "default-subnet-group"
  }
}

# RDS
module "rds" {
  source                           = "./modules/rds"
  db_name                          = var.db_name
  db_username                      = var.db_username
  db_password                      = var.db_password
  db_tags                          = var.db_tags
  private_subnet_ids               = module.vpc.private_subnet_ids
  vpc_id                           = module.vpc.vpc_id
  security_group_id                = module.security_groups.rds_sg_id # Теперь это корректный выход
  performance_insights_kms_key_arn = module.iam.rds_performance_insights_key_arn
  monitoring_role_arn              = module.iam.rds_monitoring_role_arn
}
