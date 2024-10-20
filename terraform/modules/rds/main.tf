# Local variables for common tags
locals {
  common_tags = merge(
    { Name = var.db_name },
    var.db_tags
  )
}

# Define the RDS instance with enhanced security settings
resource "aws_db_instance" "mysql" {
  allocated_storage                   = 20                                   # Specify allocated storage size
  storage_type                        = "gp2"                                # Specify storage type
  engine                              = "mysql"                              # Specify database engine
  engine_version                      = "5.7"                                # Specify engine version
  instance_class                      = "db.t2.micro"                        # Specify instance class
  identifier                          = var.db_name                          # Specify database identifier
  username                            = var.db_username                      # Specify database username
  password                            = var.db_password                      # Specify database password
  db_subnet_group_name                = aws_db_subnet_group.default.name     # Specify subnet group name
  skip_final_snapshot                 = true                                 # Skip final snapshot upon deletion
  publicly_accessible                 = false                                # Avoid public access
  backup_retention_period             = 30                                   # Set backup retention
  multi_az                            = true                                 # Enable multi-AZ for high availability
  storage_encrypted                   = true                                 # Enable storage encryption
  deletion_protection                 = true                                 # Enable deletion protection
  iam_database_authentication_enabled = true                                 # Enable IAM authentication
  performance_insights_enabled        = true                                 # Enable Performance Insights
  performance_insights_kms_key_id     = var.performance_insights_kms_key_arn # Use the KMS key passed from main module

  # Enable enhanced monitoring
  monitoring_interval = 60                      # Interval in seconds
  monitoring_role_arn = var.monitoring_role_arn # Use the IAM role passed from main module

  # Enable automatic minor upgrades
  auto_minor_version_upgrade = true

  # Enable necessary logs
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"] # Enable logs

  vpc_security_group_ids = [aws_security_group.rds_sg.id] # Specify VPC security group IDs

  # Ensure RDS instance with copy tags to snapshots is enabled
  copy_tags_to_snapshot = true

  tags = local.common_tags # Specify tags
}

# Define the DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "rds-subnet-group"
  }
}
