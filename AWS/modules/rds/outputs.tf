output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

output "db_username" {
  description = "Username for the RDS instance"
  value       = var.db_username
}

output "db_password" {
  description = "Password for the RDS instance"
  value       = var.db_password
}
