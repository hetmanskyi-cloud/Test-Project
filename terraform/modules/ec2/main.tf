# Define local variables
locals {
  base_tags = merge(
    { Name = var.instance_name },
    var.instance_tags
  )
}

# Define the EC2 launch template
resource "aws_launch_template" "ec2" {
  name_prefix            = "ec2-"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id] # Use the security group ID from variable

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  network_interfaces {
    subnet_id       = element(var.subnet_ids, 0) # Use the first subnet from the list
    security_groups = [var.security_group_id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data_nginx.sh", {}))

  # Enable HTTP token requirement for IMDS
  metadata_options {
    http_tokens = "required"
  }

  # Tags for the EC2 instances
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

resource "aws_instance" "example" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = element(var.subnet_ids, 0)     # Указываем первую подсеть
  vpc_security_group_ids = [aws_security_group.ec2_sg.id] # Привязка Security Group

  tags = var.instance_tags
}
