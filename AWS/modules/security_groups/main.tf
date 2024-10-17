locals {
  ec2_ingress_rules = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },  # SSH
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },  # HTTP
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] } # HTTPS
  ]

  rds_ingress_rules = [
    { from_port = 3306, to_port = 3306, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }  # MySQL
  ]
}

# EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name        = var.ec2_sg_name
  description = "Security Group for EC2 instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ec2_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = var.ec2_sg_name
    },
    var.ec2_sg_tags
  )
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = var.rds_sg_name
  description = "Security Group for RDS instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.rds_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = var.rds_sg_name
    },
    var.rds_sg_tags
  )
}
