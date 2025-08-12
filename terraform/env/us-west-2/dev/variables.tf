
# EC2
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "tags_ansible_ec2" {
  type    = map(string)
  default = {}
}

# sg
variable "name_sg" {
  type = string
}

variable "description" {
  type = string
}

variable "tags_vpc" {
  type    = map(string)
  default = {}
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

# Module VPC
variable "name_vpc" {
  description = "Nombre base para los recursos (prefijo en tags)"
  type        = string
}

variable "cidr_block" {
  description = "CIDR principal de la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de subnets públicas CIDR, una por AZ"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de subnets privadas CIDR, una por AZ"
  type        = list(string)
}

variable "azs" {
  description = "Lista de availability zones donde desplegar subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags adicionales para todos los recursos"
  type        = map(string)
  default     = {}
}

variable "region" {
  type = string
}

# asg
variable "name_asg" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

# eks
variable "eks_name"          { type = string }
variable "eks_instance_type" { type = string }
variable "eks_desired"       { type = number }
variable "eks_min"           { type = number }
variable "eks_max"           { type = number }

# Ansible Core usando CMK(KMS)
variable "kms_description" {
  type = string
}

variable "enable_key_rotation" {
  type = bool
}

variable "kms_name" {
  type = string
}

variable "ansible_secret" {
  description = "Secreto a cifrar con KMS para Ansible Core"
  type        = string
  sensitive   = true
}
variable "iam_instance_profile" {
  description = "Nombre del IAM Instance Profile con permisos para usar la CMK"
  type        = string
}
