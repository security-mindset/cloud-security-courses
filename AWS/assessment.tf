# # Define AWS Inspector assessment template and target
# resource "aws_inspector_assessment_target" "smassess" {
#   name = "smssss-target"
# }

# resource "aws_inspector_assessment_template" "smassess" {
#   name                = "smsss-assessment"
#   duration            = 10  # Duration of the assessment in seconds
#   rules_package_arns  = [
#     "arn:aws:inspector:us-east-1:342609973047:rulespackage/0-9hgA516p"
#     # Add more rules packages as needed
#   ]
  
#   target_arn = aws_inspector_assessment_target.smassess.arn
# }