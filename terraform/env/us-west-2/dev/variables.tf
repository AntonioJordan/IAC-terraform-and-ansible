# --- VPC ---
variable "name_vpc" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)

  validation {
    condition     = length(var.public_subnets) == length(var.azs) && length(var.private_subnets) == length(var.azs)
    error_message = "Debe haber exactamente una subnet pública y una privada por AZ."
  }
}

variable "region" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# --- EKS ---
variable "eks_name" {
  type = string
}

variable "eks_instance_type" {
  type = string
}

variable "eks_desired" {
  type = number
}

variable "eks_min" {
  type = number
}

variable "eks_max" {
  type = number
}

# --- IAM para Ansible Core ---
variable "iam_control_role_name" {
  type = string
}

variable "iam_control_instance_profile_name" {
  type = string
}

# --- Ansible Core ---
variable "ansible_secret" {
  type      = string
  sensitive = true
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "tags_ansible_core" {
  type    = map(string)
  default = {}
}

# --- ALB ---
variable "name_alb" {
  type = string
}

# --- Seguridad ---
variable "my_ip" {
  description = "Dirección IP desde la que se permite SSH (formato CIDR, ej. 1.2.3.4/32)"
  type        = string
}
