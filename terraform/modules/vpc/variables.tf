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
