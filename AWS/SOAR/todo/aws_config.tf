resource "aws_config_configuration_recorder" "main" {
  name     = "main"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "main" {
  name      = aws_config_configuration_recorder.main.name
  is_enabled = true
}

resource "aws_config_delivery_channel" "main" {
  name           = "main"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket

  depends_on = [aws_config_configuration_recorder.main]
}

resource "aws_s3_bucket" "config_bucket" {
  bucket = "my-config-bucket"
  acl    = "private"
}

resource "aws_iam_role" "config_role" {
  name = "config_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "config.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "config_role_policy" {
  name = "config_role_policy"
  role = aws_iam_role.config_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ],
        Resource = [
          "${aws_s3_bucket.config_bucket.arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "iam:ListRoles",
          "iam:GetRole"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "config:Put*",
          "config:Deliver*",
          "config:Get*",
          "config:List*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_config_config_rule" "ec2_instance_types" {
  name = "ec2-instance-types"
  source {
    owner             = "AWS"
    source_identifier = "EC2_INSTANCE_TYPE"
  }

  maximum_execution_frequency = "TwentyFour_Hours"
}
