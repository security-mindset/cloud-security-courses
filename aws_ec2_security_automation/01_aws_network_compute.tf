provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"
  region                  = var.region
  vpc_cidr_block          = var.vpc_cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  availability_zones      = ["${var.region}a", "${var.region}b"]
  tags = {
    Environment = "dev"
  }
}
resource "aws_launch_template" "example" {
  name_prefix   = "sm-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = module.network.public_subnet_ids[0] // Utilisation du premier subnet public
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
    }
  }
  # security_group_names = [aws_security_group.sm_sg.name]

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_inspector_instance_profile.name
  }

    user_data = base64encode(<<-EOF
              #!/bin/bash
              snap install amazon-ssm-agent --classic
              systemctl start snap.amazon-ssm-agent.amazon-ssm-agent
              systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent
              wget https://inspector-agent.amazonaws.com/linux/latest/install
              bash install
              systemctl start awsagent
              systemctl enable awsagent
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "inspector-instance"
    }
  }
}
# resource "aws_security_group" "sm_sg" {
#   name        = "sm-sg"
#   description = "Allow SSH inbound traffic"
#   vpc_id      = aws_vpc.main.id
  
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   tags = {
#     Name = "sm-sg"
#   }
# }
resource "aws_autoscaling_group" "example" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = module.network.public_subnet_ids

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "sm-asg"
    propagate_at_launch = true
  }
}



resource "aws_s3_bucket" "ssm_inventory_bucket" {
  bucket = "sm-unique-ssm-inventory-bucket-name"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "ssm-inventory-bucket"
    Environment = "dev"
  }
}
