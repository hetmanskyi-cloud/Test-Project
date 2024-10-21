# Define local variables
locals {
  base_tags = merge(
    { Name = var.instance_name },
    var.instance_tags
  )
}

resource "aws_launch_template" "ec2" {
  name_prefix            = "example-"
  image_id               = aws_instance.ec2_instance.ami
  instance_type          = aws_instance.ec2_instance.instance_type
  key_name               = aws_instance.ec2_instance.key_name
  vpc_security_group_ids = aws_instance.ec2_instance.vpc_security_group_ids

  metadata_options {
    http_tokens = "required"
  }

  block_device_mappings {
    device_name = aws_instance.ec2_instance.root_block_device[0].device_name
    ebs {
      encrypted             = true
      volume_size           = aws_instance.ec2_instance.root_block_device[0].volume_size
      volume_type           = aws_instance.ec2_instance.root_block_device[0].volume_type
      delete_on_termination = aws_instance.ec2_instance.root_block_device[0].delete_on_termination
    }
  }

  network_interfaces {
    subnet_id       = aws_instance.ec2_instance.subnet_id
    security_groups = aws_instance.ec2_instance.vpc_security_group_ids
  }

  user_data = base64encode(templatefile("${path.module}/user_data_nginx.sh", {}))
  tags      = local.base_tags
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = element(var.subnet_ids, 0)
  ebs_optimized          = true
  monitoring             = true
  iam_instance_profile   = var.instance_profile_name
  tags                   = var.instance_tags

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }
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
