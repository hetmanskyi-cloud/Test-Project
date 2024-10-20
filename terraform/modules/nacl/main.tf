# Create a Network ACL for public subnets
resource "aws_network_acl" "public" {
  vpc_id = var.vpc_id # Используем переменную vpc_id
  tags = {
    Name = "public-nacl"
  }
}

# Create a Network ACL for private subnets
resource "aws_network_acl" "private" {
  vpc_id = var.vpc_id # Используем переменную vpc_id
  tags = {
    Name = "private-nacl"
  }
}

# Define local variables for the public subnet CIDR blocks
locals {
  public_subnet_cidr_blocks = [
    "10.0.1.0/24" # Add more specific CIDR blocks as needed
  ]
}

# Allow inbound traffic from the public subnet CIDR ranges to the private subnets
resource "aws_network_acl_rule" "allow_public_inbound" {
  count          = length(local.public_subnet_cidr_blocks)
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100 + count.index * 10
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false # Inbound traffic
  cidr_block     = local.public_subnet_cidr_blocks[count.index]
  from_port      = 80 # Specify allowed port range
  to_port        = 80
}

# Deny all other inbound traffic to the private subnets
resource "aws_network_acl_rule" "deny_all_inbound" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  protocol       = "tcp" # Specify protocol
  rule_action    = "deny"
  egress         = false # Inbound traffic
  cidr_block     = "0.0.0.0/0"
  from_port      = 1     # Deny from port 1 (use a more restrictive range)
  to_port        = 65534 # Deny to port 65534 (use a more restrictive range)
}

# Network ACL Rule for outbound traffic with specific protocol
resource "aws_network_acl_rule" "allow_all_outbound" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 300
  protocol       = "tcp" # Specify protocol instead of all
  rule_action    = "allow"
  egress         = true          # Outbound traffic
  cidr_block     = "10.0.0.0/16" # More restrictive CIDR range
  from_port      = 0             # Allow from port 0 (or specify a different port)
  to_port        = 65535         # Allow to port 65535 (or specify a different range)
}

# Associate NACL with public subnets
resource "aws_network_acl_association" "public" {
  count          = length(local.public_subnet_cidr_blocks)
  network_acl_id = aws_network_acl.public.id
  subnet_id      = element(var.public_subnet_ids, count.index)
}

# Associate NACL with private subnets
resource "aws_network_acl_association" "private" {
  count          = length(var.private_subnet_ids)
  network_acl_id = aws_network_acl.private.id
  subnet_id      = element(var.private_subnet_ids, count.index)
}
