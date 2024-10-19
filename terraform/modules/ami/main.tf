# Define local variables for AMI filters
locals {
  ami_filters = [
    { name = "name", values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"] },
    { name = "virtualization-type", values = ["hvm"] },
    { name = "root-device-type", values = ["ebs"] },
    { name = "architecture", values = ["x86_64"] },
    { name = "state", values = ["available"] }
  ]
}

# Find the latest Ubuntu AMI based on the provided filters
data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  dynamic "filter" {
    for_each = local.ami_filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}

# Output the ID of the latest Ubuntu AMI
output "ami_id" {
  description = "Latest Ubuntu AMI ID"
  value       = data.aws_ami.latest_ubuntu.id
}
