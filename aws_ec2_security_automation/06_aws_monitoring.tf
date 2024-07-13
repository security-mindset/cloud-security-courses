# Create CloudWatch Alarm

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.sm_asg.name
  }

  alarm_actions = [aws_sns_topic.sm_topic.arn]
}

# Create CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "ec2_instance_state_change" {
  name        = "ec2-instance-state-change"
  event_pattern = jsonencode({
    "source": [
      "aws.ec2"
    ],
    "detail-type": [
      "EC2 Instance State-change Notification"
    ],
    "detail": {
      "state": [
        "running"
      ]
    }
  })
}

# Create CloudWatch Event Target
resource "aws_cloudwatch_event_target" "ec2_instance_state_change" {
  rule      = aws_cloudwatch_event_rule.ec2_instance_state_change.name
  target_id = "lambda"
  arn       = aws_lambda_function.isolation_function.arn
}
