variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the launch configuration"
  default     = "ami-06c68f701d8090592"

}
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
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
