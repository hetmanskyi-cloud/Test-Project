# Define the instance type for the EC2 instances
variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

# Define the key name for SSH access
variable "key_name" {
  description = "Key name for SSH access"
  type        = string
}

# Define the VPC ID where the EC2 instances will be created
variable "vpc_id" {
  description = "VPC ID where the EC2 instances will be created"
  type        = string
}

# Define the list of subnet IDs for the EC2 instances
variable "subnet_ids" {
  description = "List of subnet IDs for the EC2 instances"
  type        = list(string)
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

# Define the Security Group ID for the EC2 instances
variable "security_group_id" {
  description = "Security Group ID for the EC2 instances"
  type        = string
}

# Define the AMI ID for the EC2 instance
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}
