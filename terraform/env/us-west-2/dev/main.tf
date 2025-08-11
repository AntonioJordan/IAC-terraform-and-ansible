
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
  source                 = "../../../modules/aws/vpc"
  name_vpc               = var.name_vpc
  cidr_block             = var.cidr_block
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  azs                    = var.azs
  tags                   = var.tags
  region                 = var.region
  eks_security_group_id  = module.security_group.security_group_id
}

# sg
module "security_group" {
  source      = "../../../modules/aws/sg"
  vpc_id      = module.vpc.vpc_id
  name_sg     = var.name_sg
  description = var.description
}

# ec2

# ec2 para Ansible Controller
module "ec2" {
  source              = "../../../modules/aws/ec2"
  subnet_id           = module.vpc.public_subnet_ids[0]
  instance_type       = var.instance_type
  tags                = var.tags_ansible_ec2
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
  name_asg            = var.name_asg
  ami                 = data.aws_ami.amazon_linux.id
  instance_type       = var.instance_type
  security_group_ids  = [module.security_group.security_group_id]
  subnet_ids          = module.vpc.public_subnet_ids
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
}

# iam
module "eks_iam" {
  source       = "../../../modules/aws/iam"
  cluster_name = var.eks_name
}

# eks
module "eks" {
  source           = "../../../modules/aws/eks"
  name             = var.eks_name

  cluster_role_arn = module.eks_iam.eks_cluster_role_arn
  node_role_arn    = module.eks_iam.eks_node_role_arn

  private_subnets  = module.vpc.private_subnet_ids
  instance_type    = var.eks_instance_type
  desired          = var.eks_desired
  min              = var.eks_min
  max              = var.eks_max
}
