variable "ami" {
  description = "AMI ID para la instancia"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred donde desplegar"
  type        = string
}

variable "security_group_ids" {
  description = "Lista de Security Group IDs para la instancia"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "Nombre del IAM Instance Profile con permisos KMS"
  type        = string
}

variable "region" {
  description = "Región AWS"
  type        = string
}

variable "kms_key_id" {
  description = "ID de la CMK existente (de module.kms)"
  type        = string
}

variable "ansible_secret" {
  description = "Secreto a cifrar para Ansible"
  type        = string
  sensitive   = true
}

variable "root_volume_type" {
  description = "Tipo de volumen raíz"
  type        = string
  default     = "gp3"
}

variable "tags_ansible_core" {
  description = "Mapa de etiquetas a aplicar a los recursos"
  type        = map(string)
}

