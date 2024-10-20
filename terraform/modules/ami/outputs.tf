# Output the ID of the latest Ubuntu AMI
output "ami_id" {
  description = "Latest Ubuntu AMI ID"
  value       = data.aws_ami.latest_ubuntu.id
}
