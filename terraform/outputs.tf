# VPC Outputs
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the created private subnets"
  value       = module.vpc.private_subnet_ids
}

# EC2 Outputs
output "ec2_instance_ids" {
  description = "IDs of the instances in the Auto Scaling group"
  value       = module.ec2.ec2_instance_ids
}

output "ec2_public_ips" {
  description = "Public IPs of the instances in the Auto Scaling group"
  value       = module.ec2.ec2_public_ips
}

# RDS Outputs
output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.rds.db_endpoint
}

output "db_username" {
  description = "Username for the RDS instance"
  value       = module.rds.db_username
}

output "db_password" {
  description = "Password for the RDS instance"
  value       = module.rds.db_password
}
