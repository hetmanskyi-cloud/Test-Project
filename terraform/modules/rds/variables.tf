# Variable for the name of the database for the RDS instance
variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
}

# Variable for the username of the database for the RDS instance
variable "db_username" {
  description = "Database username for the RDS instance"
  type        = string
}

# Variable for the password of the database for the RDS instance
variable "db_password" {
  description = "Database password for the RDS instance"
  type        = string
}

# Variable for the tags for the RDS instance
variable "db_tags" {
  description = "Tags for the RDS instance"
  type        = map(string)
}

# Variable for the list of private subnet IDs for the RDS instance
variable "private_subnet_ids" {
  description = "List of private subnet IDs for the RDS instance"
  type        = list(string)
}

# Variable for the Security Group ID for the RDS instance
variable "security_group_id" {
  description = "Security Group ID for the RDS instance"
  type        = string
}

# Variable for the VPC ID for the RDS instance
variable "vpc_id" {
  description = "VPC ID for the RDS instance"
  type        = string
}
