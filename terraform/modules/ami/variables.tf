# Define the AMI name for the EC2 instance
variable "ami_name" {
  description = "AMI name filter for finding the latest AMI"
  type        = string
}

# Define the AMI owners for the EC2 instance
variable "ami_owners" {
  description = "AMI owners filter for finding the latest AMI"
  type        = list(string)
}
