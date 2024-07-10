# Overview
Ce code Terraform configure une architecture complète sur AWS, intégrant un ASG, ELB, CloudWatch, AWS Inspector, Lambda, SSM, et SNS pour gérer les instances EC2, détecter les vulnérabilités, isoler les instances compromises et notifier les administrateurs. 

# Prepare lambda function

``` 
zip lambda_function_payload.zip remediation.py
zip lambda_function_payload.zip lambda_function.py
```
#  Terraform commands
```
terraform init
terraform plan
terraform apply

```
