# Output for the endpoint of the RDS instance
output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

# Output for the username of the RDS instance
output "db_username" {
  description = "Username for the RDS instance"
  value       = var.db_username
}

# Output for the password of the RDS instance
output "db_password" {
  description = "Password for the RDS instance"
  value       = var.db_password
}

