resource "aws_iam_role" "ssm_inspector_role" {
  name               = "sm-ssm-inspector-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "inspector-role"
  }
}


resource "aws_iam_policy" "inspector_policy" {
  name        = "inspector-policy"
  description = "Policy for AWS Inspector"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "inspector:ListAssessmentTemplates",
          "inspector:DescribeAssessmentTargets",
          "inspector:DescribeAssessmentTemplates",
          "inspector:DescribeCrossAccountAccessRole",
          "inspector:ListRulesPackages",
          "inspector:SubscribeToEvent",
          "inspector:UnsubscribeFromEvent",
          "inspector:DescribeFindings",
          "inspector:ListFindings",
          "inspector:StartAssessmentRun"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ssm_policy" {
  name = "example-ssm-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:DescribeInstanceInformation",
          "ssm:GetCommandInvocation",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations",
          "ssm:SendCommand",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ssm:CreateInventory",
          "ssm:DeleteInventory",
          "ssm:DescribeInventoryDeletions",
          "ssm:GetInventory",
          "ssm:GetInventorySchema",
          "ssm:ListInventoryEntries"
        ],
        Resource = "*"
      },
       {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.ssm_inventory_bucket.arn,
          "${aws_s3_bucket.ssm_inventory_bucket.arn}/*"
        ]
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_inspector_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role = aws_iam_role.ssm_inspector_role.id
}

resource "aws_iam_role_policy_attachment" "inspector_policy_attachment" {
  role       = aws_iam_role.ssm_inspector_role.name
  policy_arn = aws_iam_policy.inspector_policy.arn
}

resource "aws_iam_instance_profile" "ssm_inspector_instance_profile" {
  name = "sm-instance-profile"
  role = aws_iam_role.ssm_inspector_role.name
}

# resource "aws_ssm_association" "inventory" {
#   name = "AWS-GatherSoftwareInventory"
#   targets {
#     key    = "InstanceIds"
#     values = ["*"]
#   }
#   schedule_expression = "rate(30 minutes)"
#   output_location {
#     s3_bucket_name = aws_s3_bucket.ssm_inventory_bucket.bucket
#   }
# }