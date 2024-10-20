# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create IAM Role for RDS monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AmazonRDSEnhancedMonitoringRole policy to the role
resource "aws_iam_role_policy_attachment" "rds_monitoring_role_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Create a KMS key for RDS Performance Insights
resource "aws_kms_key" "rds_performance_insights_key" {
  description         = "KMS key for RDS Performance Insights"
  enable_key_rotation = true

  # Define the key policy
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "Enable IAM User Permissions",
        Effect : "Allow",
        Principal : { AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
        Action : "kms:*",
        Resource : "*"
      },
      {
        Sid : "Allow access for Key Administrators",
        Effect : "Allow",
        Principal : {
          AWS : [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/admin-role"
          ]
        },
        Action : ["kms:*"],
        Resource : "*"
      },
      {
        Sid : "Allow use of the key",
        Effect : "Allow",
        Principal : { AWS : "*" },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource : "*"
      }
    ]
  })
}
