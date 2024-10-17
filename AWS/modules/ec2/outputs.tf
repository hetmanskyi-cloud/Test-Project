# Output the IDs of the instances in the Auto Scaling group
output "ec2_instance_ids" {
  description = "IDs of the instances in the Auto Scaling group"
  value       = data.aws_instances.ec2.ids
}

# Output the public IPs of the instances in the Auto Scaling group
output "ec2_public_ips" {
  description = "Public IPs of the instances in the Auto Scaling group"
  value       = data.aws_instances.ec2.public_ips
}
