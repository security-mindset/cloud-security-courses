resource "aws_sns_topic" "sm_topic" {
  name = "sm-topic"
}
resource "aws_sns_topic_subscription" "sm_email_subscription" {
  topic_arn = aws_sns_topic.sm_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email_endpoint
}

