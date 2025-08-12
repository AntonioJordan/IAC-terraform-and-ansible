instance_type = "t3.micro"

# Ansible EC2
tags_ansible_ec2 = {
  Name = "ansible-ec2"
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
name_vpc       = "dev-vpc"
cidr_block     = "10.0.0.0/16"

region = "us-west-2"
azs             = ["us-west-2a", "us-west-2b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

tags = {
  Environment = "dev"
  Project     = "eks-cluster"
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
eks_max           = 2

# CMK para ansible core
kms_description     = "KMS para Ansible Core"
enable_key_rotation = true
kms_name            = "alias/ansible-core"

# Ansible core
iam_instance_profile = "iam-profile-ansible"
ansible_secret       = "clave-super-secreta"