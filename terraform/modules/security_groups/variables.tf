# Variable for the name of the EC2 security group
variable "ec2_sg_name" {
  description = "Name of the EC2 security group"
  type        = string
}

# Variable for the VPC ID where the Security Group will be created
variable "vpc_id" {
  description = "VPC ID where the Security Group will be created"
  type        = string
}

# Variable for the tags for the EC2 security group
variable "ec2_sg_tags" {
  description = "Tags for the EC2 security group"
  type        = map(string)
}

# Variable for the name of the RDS security group
variable "rds_sg_name" {
  description = "Name of the RDS security group"
  type        = string
}

# Variable for the tags for the RDS security group
variable "rds_sg_tags" {
  description = "Tags for the RDS security group"
  type        = map(string)
}
