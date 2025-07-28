resource "aws_launch_template" "lt" {
  name_prefix   = var.name_asg
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.security_group_ids
}

resource "aws_autoscaling_group" "asg" {
  name                      = var.name_asg
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}

