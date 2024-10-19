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
  publicly_accessible                 = false                                                                         # Avoid public access
  backup_retention_period             = 30                                                                            # Set backup retention
  multi_az                            = true                                                                          # Enable multi-AZ for high availability
  storage_encrypted                   = true                                                                          # Enable storage encryption
  deletion_protection                 = true                                                                          # Enable deletion protection
  iam_database_authentication_enabled = true                                                                          # Enable IAM authentication
  performance_insights_enabled        = true                                                                          # Enable Performance Insights
  performance_insights_kms_key_id     = "arn:aws:kms:eu-west-1:739275435828:key/fb56457e-49fd-446d-b266-6ea578b8d42d" # KMS Key ID for Performance Insights encryption

  vpc_security_group_ids = [var.security_group_id]

  tags = local.common_tags
}

# Define the DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "rds-subnet-group"
  }
}
