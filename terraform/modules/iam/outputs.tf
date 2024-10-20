# Output the ARN of the IAM role created for RDS monitoring
output "rds_monitoring_role_arn" {
  description = "ARN of the IAM role for RDS monitoring"
  value       = aws_iam_role.rds_monitoring_role.arn
}

# Output the ARN of the KMS key created for RDS Performance Insights encryption
output "rds_performance_insights_key_arn" {
  description = "ARN of the KMS key for RDS Performance Insights"
  value       = aws_kms_key.rds_performance_insights_key.arn
}
