
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# vpc
module "vpc" {
  source         = "../../../modules/aws/vpc"
  cidr_block     = var.cidr_block
  public_subnets = var.public_subnets
  azs            = var.azs
  tags           = var.tags
}

# sg
module "security_group" {
  source      = "../../../modules/aws/sg"
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags
  name        = "security_group_ec2"
  description = "Security group for EC2 instance"
}

# ec2
module "ec2" {
  source              = "../../../modules/aws/ec2"
  subnet_id           = module.vpc.public_subnet_ids[0]
  instance_type       = var.instance_type
  tags                = var.tags_ec2
  ami                 = data.aws_ami.amazon_linux.id
  security_group_ids  = [module.security_group.security_group_id]
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# asg
module "asg" {
  source              = "../../../modules/aws/asg"
  name                = var.name_asg
  ami                 = data.aws_ami.amazon_linux.id
  instance_type       = var.instance_type
  security_group_ids  = [module.security_group.security_group_id]
  subnet_ids          = module.vpc.public_subnet_ids
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  tags_asg            = var.tags_asg
}
