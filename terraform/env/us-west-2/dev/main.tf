terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# --- Security Group principal ---
resource "aws_security_group" "main" {
  name        = "${var.name_vpc}_main_sg"
  description = "SG general para ALB, EKS y Ansible Core"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Permitir HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Permitir HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH solo desde tu IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_vpc}_main_sg" })
}

# --- VPC con 2 públicas + 2 privadas + NATs + endpoints ---
module "vpc" {
  source          = "../../../modules/aws/vpc"
  name_vpc        = var.name_vpc
  cidr_block      = var.cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  tags            = var.tags
  region          = var.region
}

# --- KMS para cifrado de secretos ---
module "kms" {
  source              = "../../../modules/aws/kms"
  name                = "ansible-core"
  description         = "KMS para Ansible Core"
  enable_key_rotation = true
  tags                = var.tags
}

# --- IAM para EKS ---
module "eks_iam" {
  source       = "../../../modules/aws/iam/iam_eks"
  cluster_name = var.eks_name
}

# --- IAM para Ansible Core ---
module "iam_ansible_core" {
  source                = "../../../modules/aws/iam/iam_ansible_core"
  role_name             = var.iam_control_role_name
  instance_profile_name = var.iam_control_instance_profile_name
  kms_key_arn           = module.kms.kms_key_arn
}

# --- Secreto encriptado con KMS ---
resource "aws_kms_ciphertext" "ansible_secret" {
  key_id    = module.kms.kms_key_id
  plaintext = var.ansible_secret
}

# --- EKS (control plane gestionado, nodos en privadas) ---
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

# --- EC2 Ansible Core en subnet privada ---
module "ec2_ansible_core" {
  source               = "../../../modules/aws/ec2/ec2_ansible_core"
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  subnet_id            = module.vpc.private_subnet_ids[0]
  security_group_ids   = [aws_security_group.main.id]
  iam_instance_profile = module.iam_ansible_core.instance_profile_name
  key_name             = var.key_name
  tags_ansible_core    = var.tags_ansible_core
  region               = var.region
  repo_url             = "https://github.com/AntonioJordan/IAC-terraform-and-ansible.git"
  inventory_rel_path   = "ansible/inventories/aws/dev/aws_ec2.yaml"
  ansible_secret_blob  = aws_kms_ciphertext.ansible_secret.ciphertext_blob
}

# --- ALB (en subnets públicas) ---
module "alb" {
  source            = "../../../modules/aws/alb"
  name_alb          = var.name_alb
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnet_ids
  security_group_id = aws_security_group.main.id

  target_group_arns = [] # pendiente de definir
}

# --- Imagen Amazon Linux 2 ---
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
