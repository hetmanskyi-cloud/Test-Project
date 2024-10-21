# Variable for VPC ID
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# Variable for public subnet IDs
variable "public_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

# Variable for private subnet IDs
variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "ID of the EC2 Security Group"
  type        = string
}

variable "rds_sg_id" {
  description = "ID of the RDS Security Group"
  type        = string
}