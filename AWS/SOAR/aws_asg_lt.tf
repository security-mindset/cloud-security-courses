resource "aws_autoscaling_group" "sm_asg" {
  name                      = "sm-asg"
  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  health_check_type    = "EC2"

  launch_template {
    id      = aws_launch_template.sm_lt.id
    version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "sm-instance"
    propagate_at_launch = true
  }
 
}

resource "aws_launch_template" "sm_lt" {
  name_prefix   = "sm-lt-"
  description   = "Sm Launch Template"
  instance_type = var.instance_type
  image_id      = var.ami_id
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.volume_size
    }
  }
 
}