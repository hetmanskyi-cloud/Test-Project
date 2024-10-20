# VPC variables

# Define the AWS region where resources will be created
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

# Define the CIDR block for the VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

# Define the number of public subnets to create
variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
}

# Define the number of private subnets to create
variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
}

# Define the list of CIDR masks for public subnets
variable "public_subnet_masks" {
  description = "List of CIDR masks for public subnets"
  type        = list(number)
}

# Define the list of CIDR masks for private subnets
variable "private_subnet_masks" {
  description = "List of CIDR masks for private subnets"
  type        = list(number)
}

# Define the name for the VPC
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

# Define tags for the VPC
variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
}

# Define tags for the subnets
variable "subnet_tags" {
  description = "Tags for the subnets"
  type        = map(string)
}

# Security Group variables

# Variable for security group ID
variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

# Define the name of the EC2 security group
variable "ec2_sg_name" {
  description = "Name of the EC2 security group"
  type        = string
}

# Define the tags for the EC2 security group
variable "ec2_sg_tags" {
  description = "Tags for the EC2 security group"
  type        = map(string)
}

# Define the name of the RDS security group
variable "rds_sg_name" {
  description = "Name of the RDS security group"
  type        = string
}

# Define the tags for the RDS security group
variable "rds_sg_tags" {
  description = "Tags for the RDS security group"
  type        = map(string)
}

# AMI variables

# Define the AMI name for the EC2 instance
variable "ami_name" {
  description = "AMI name filter for finding the latest AMI"
  type        = string
}

# Define the AMI owners for the EC2 instance
variable "ami_owners" {
  description = "AMI owners filter for finding the latest AMI"
  type        = list(string)
}

# EC2 variables

# Define the instance type for the EC2 instances
variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

# Define the SSH key name for EC2 instances
variable "key_name" {
  description = "Key name for SSH access"
  type        = string
}

# Define the desired capacity for the Auto Scaling group
variable "desired_capacity" {
  description = "Desired capacity for the Auto Scaling group"
  type        = number
}

# Define the minimum size for the Auto Scaling group
variable "min_size" {
  description = "Minimum size for the Auto Scaling group"
  type        = number
}

# Define the maximum size for the Auto Scaling group
variable "max_size" {
  description = "Maximum size for the Auto Scaling group"
  type        = number
}

# Define the EBS volume size for the root volume
variable "ebs_volume_size" {
  description = "EBS volume size for the root volume"
  type        = number
}

# Define the instance name for the EC2 instances
variable "instance_name" {
  description = "Instance name for the EC2 instances"
  type        = string
}

# Define tags for the EC2 instances
variable "instance_tags" {
  description = "Tags for the EC2 instances"
  type        = map(string)
}

# RDS variables

# Database name for the RDS instance
variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
}

# Database username for the RDS instance
variable "db_username" {
  description = "Database username for the RDS instance"
  type        = string
}

# Database password for the RDS instance
variable "db_password" {
  description = "Database password for the RDS instance"
  type        = string
}

# Tags for the RDS instance
variable "db_tags" {
  description = "Tags for the RDS instance"
  type        = map(string)
}
