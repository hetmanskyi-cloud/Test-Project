# Local variables for common tags
locals {
  common_tags = merge(
    { Name = var.db_name },
    var.db_tags
  )
}

# Define the RDS instance
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot  = true

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
