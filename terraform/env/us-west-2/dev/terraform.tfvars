instance_type = "t3.micro"

tags_ec2 = {
  Name = "ec2-dev"
  Env  = "dev"
}

# SG
name_sg        = "security_group_ec2"
description = "Allow SSH and HTTP"

ingress_rules = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

# VPC
cidr_block     = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
azs            = ["us-west-2a", "us-west-2b"]
tags = {
  Name = "vpc-dev"
  Env  = "dev"
}

# asg
name_asg          = "asg-dev"
min_size          = 1
max_size          = 2
desired_capacity  = 1

# eks
eks_name          = "dev-eks"
eks_instance_type = "t3.micro"
eks_desired       = 2
eks_min           = 1
eks_max           = 3
