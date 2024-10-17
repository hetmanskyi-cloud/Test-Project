variable "ec2_sg_name" {
  description = "Name of the EC2 security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Security Group will be created"
  type        = string
}

variable "ec2_sg_tags" {
  description = "Tags for the EC2 security group"
  type        = map(string)
}

variable "rds_sg_name" {
  description = "Name of the RDS security group"
  type        = string
}

variable "rds_sg_tags" {
  description = "Tags for the RDS security group"
  type        = map(string)
}
