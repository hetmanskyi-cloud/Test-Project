variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Database username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Database password for the RDS instance"
  type        = string
}

variable "db_tags" {
  description = "Tags for the RDS instance"
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the RDS instance"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for the RDS instance"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the RDS instance"
  type        = string
}
