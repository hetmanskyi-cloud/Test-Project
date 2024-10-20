# Define local variables for AMI filters
locals {
  ami_filters = [
    { name = "name", values = [var.ami_name] }, # Use variable ami_name
    { name = "virtualization-type", values = ["hvm"] },
    { name = "root-device-type", values = ["ebs"] },
    { name = "architecture", values = ["x86_64"] },
    { name = "state", values = ["available"] }
  ]
}

# Find the latest Ubuntu AMI based on the provided filters
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = var.ami_owners # Use variable ami_owners

  dynamic "filter" {
    for_each = local.ami_filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}
