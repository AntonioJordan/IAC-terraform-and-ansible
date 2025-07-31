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

variable "eks_security_group_id" {
  type = string
}
