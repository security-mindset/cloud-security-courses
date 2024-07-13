resource "aws_cloudwatch_event_rule" "inspector_event_rule" {
  name                = "inspector-findings-rule"
  event_pattern       = <<PATTERN
{
  "source": ["aws.inspector"],
  "detail-type": ["Inspector Findings Change"],
  "detail": {
    "state": ["NEW"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.inspector_event_rule.name
  target_id = "lambda-target"
  arn       = aws_lambda_function.inspector_lambda.arn
}



