# Define AWS Inspector assessment template and target
resource "aws_inspector_assessment_target" "sm" {
  name = "sm-target"
}

resource "aws_inspector_assessment_template" "sm" {
  name                = "sm-assessment"
  duration            = 10  # Duration of the assessment in seconds
  rules_package_arns  = [
    "arn:aws:inspector:us-east-1:XXXXXXXX:rulespackage/0-9hgA516p"
    # Add more rules packages as needed
  ]
  
  target_arn = aws_inspector_assessment_target.sm.arn
}