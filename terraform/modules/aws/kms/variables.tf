variable "name" {
  type        = string
  description = "Alias para la CMK (sin 'alias/' delante)"
}

variable "description" {
  type        = string
  description = "Descripción de la CMK"
}

variable "enable_key_rotation" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
