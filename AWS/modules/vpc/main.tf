# Create a Virtual Private Cloud (VPC) with the specified CIDR block and tags
resource "aws_vpc" "custom" {
  cidr_block = var.vpc_cidr_block
  tags       = merge({ Name = var.vpc_name }, var.vpc_tags)
}

locals {
  public_masks  = length(var.public_subnet_masks) == var.public_subnet_count ? var.public_subnet_masks : [for i in range(var.public_subnet_count) : 24]
  private_masks = length(var.private_subnet_masks) == var.private_subnet_count ? var.private_subnet_masks : [for i in range(var.private_subnet_count) : 24]
}

# Create public subnets within the VPC
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.custom.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 32 - local.public_masks[count.index], count.index)
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "public-subnet-${count.index}" }, var.subnet_tags)
}

# Create private subnets within the VPC
resource "aws_subnet" "private" {
  count      = var.private_subnet_count
  vpc_id     = aws_vpc.custom.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 32 - local.private_masks[count.index], count.index + var.public_subnet_count)
  tags       = merge({ Name = "private-subnet-${count.index}" }, var.subnet_tags)
}

# Create an Internet Gateway to allow internet access for public subnets
resource "aws_internet_gateway" "custom" {
  vpc_id = aws_vpc.custom.id
  tags   = merge({ Name = "custom-igw" }, var.vpc_tags)
}

# Create a route table for the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom.id
  }
  tags = merge({ Name = "public-route-table" }, var.vpc_tags)
}

# Associate the public route table with public subnets
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Create a route table for the private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.custom.id
  tags   = merge({ Name = "private-route-table" }, var.vpc_tags)
}

# Associate the private route table with private subnets
resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
