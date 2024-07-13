variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the launch configuration"
  default     = "ami-03db1a48758a57ae6"

}
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable  "public_subnet_cidr_blocks" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
  type    = list(string)
}

variable "subnet_cidr_blocks" {
  default = {
    public_subnet_1 = "10.0.1.0/24"
    public_subnet_2 = "10.0.2.0/24"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "volume_size" {
  default = 30
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 2
}

variable "desired_capacity" {
  default = 2
}

variable "sns_email_endpoint" {
  default = "linsan.saliou@gmail.com"
}

variable "bucket_name" {
  default = "sm-logs-bucket"
}

variable "assessment_target_arns" {
  type        = list(string)
  description = "List of ARNs of AWS Inspector assessment targets"
  default     = ["arn:aws:inspector:us-east-1:342609973047:target/0-0kFIPusq"]
}

variable "rules_package_arns" {
  type        = list(string)
  description = "List of ARNs of AWS Inspector rules packages"
  default     = ["arn:aws:inspector:us-east-1:342609973047:rulespackage/0-9hgA516p"]
}
