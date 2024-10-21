# Local variables for common tags
locals {
  common_tags = merge(
    { Name = var.db_name },
    var.db_tags
  )
}

# Define the RDS instance with enhanced security settings
resource "aws_db_instance" "mysql" {
  allocated_storage                   = 20
  storage_type                        = "gp2"
  engine                              = "mysql"
  engine_version                      = "5.7"
  instance_class                      = "db.t2.micro"
  identifier                          = var.db_name
  username                            = var.db_username
  password                            = var.db_password
  db_subnet_group_name                = aws_db_subnet_group.default.name
  skip_final_snapshot                 = true
  publicly_accessible                 = false
  backup_retention_period             = 30
  multi_az                            = true
  storage_encrypted                   = true
  deletion_protection                 = true
  iam_database_authentication_enabled = true
  performance_insights_enabled        = true
  performance_insights_kms_key_id     = var.performance_insights_kms_key_arn
  monitoring_interval                 = 60
  monitoring_role_arn                 = var.monitoring_role_arn
  auto_minor_version_upgrade          = true
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  copy_tags_to_snapshot               = true
  vpc_security_group_ids              = [var.security_group_id] # Используем выход модуля
  tags                                = local.common_tags
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "rds-subnet-group"
  }
}
