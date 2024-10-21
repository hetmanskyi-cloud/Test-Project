locals {
  # Ingress rules for EC2 security group
  ec2_ingress_rules = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"], description = "SSH access from internal network" },    # SSH access from internal network
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"], description = "HTTP access from internal network" },   # HTTP access from internal network
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"], description = "HTTPS access from internal network" } # HTTPS access from internal network
  ]

  # Ingress rules for RDS security group
  rds_ingress_rules = [
    { from_port = 3306, to_port = 3306, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"], description = "MySQL access from internal network" } # MySQL access from internal network
  ]
}

# Default Security Group
resource "aws_default_security_group" "default" {
  vpc_id = var.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = []
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = []
  }

  tags = {
    Name = "default-security-group"
  }
}

# EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  # Ensure that this security group is attached to an instance or ENI
  # Security Group attachment is managed through instance creation module
  name        = var.ec2_sg_name
  description = "Security Group for EC2 instances"
  vpc_id      = var.vpc_id

  # Define ingress rules for EC2 instances
  dynamic "ingress" {
    for_each = local.ec2_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  # Define egress rule allowing all outbound traffic to internal network
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"] # More restrictive CIDR range
    description = "Allow all outbound traffic to internal network"
  }

  # Define tags for the EC2 security group
  tags = merge(
    { Name = var.ec2_sg_name },
    var.ec2_sg_tags
  )
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  # Ensure that this security group is attached to an instance or ENI
  # Security Group attachment is managed through RDS instance creation module
  name        = var.rds_sg_name
  description = "Security Group for RDS instances"
  vpc_id      = var.vpc_id

  # Define ingress rules for RDS instances
  dynamic "ingress" {
    for_each = local.rds_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  # Define egress rule allowing all outbound traffic to internal network
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"] # More restrictive CIDR range
    description = "Allow all outbound traffic to internal network"
  }

  # Define tags for the RDS security group
  tags = merge(
    { Name = var.rds_sg_name },
    var.rds_sg_tags
  )
}
