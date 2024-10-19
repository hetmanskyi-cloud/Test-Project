# Define local variables
locals {
  base_tags = merge(
    {
      Name = var.instance_name
    },
    var.instance_tags
  )
}

# Define the EC2 launch template
resource "aws_launch_template" "ec2" {
  name_prefix   = "ec2-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  network_interfaces {
    security_groups = [var.security_group_id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data_nginx.sh", {}))

  # Enable HTTP token requirement for IMDS
  metadata_options {
    http_tokens = "required"
  }

  tags = local.base_tags
}

# Define the EC2 Auto Scaling group
resource "aws_autoscaling_group" "ec2" {
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "autoscaling-ec2"
    propagate_at_launch = true
  }
}

# Define the data source to get instances in the Auto Scaling group
data "aws_instances" "ec2" {
  filter {
    name   = "tag:Name"
    values = ["autoscaling-ec2"]
  }
}
