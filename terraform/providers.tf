# Configure the minimum required Terraform version and the AWS provider
terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Define the AWS provider and set the region from a variable
provider "aws" {
  region = var.aws_region
}
