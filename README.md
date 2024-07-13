# Overview
This Terraform code sets up a complete architecture on AWS, integrating an ASG, ELB, CloudWatch, AWS Inspector, Lambda, SSM, and SNS to manage EC2 instances, detect vulnerabilities, isolate compromised instances, and notify administrators.

# Prepare lambda function

``` 
zip lambda_function_payload.zip lambda_function.py
```
#  Terraform commands
```
terraform init
terraform plan
terraform apply

```
