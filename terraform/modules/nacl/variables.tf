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
