
resource "aws_lambda_function" "inspector_lambda" {
  filename         = "lambda_function_payload.zip"  
  function_name    = "inspectorLambdaFunction"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.sm_topic.arn
    }
  }

  tags = {
    Name = "Inspector Lambda Function"
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_inspector_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "lambda_inspector_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "sns:Publish",
          "inspector:ListFindings",
          "inspector:DescribeFindings",
          "inspector:TagResource"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
