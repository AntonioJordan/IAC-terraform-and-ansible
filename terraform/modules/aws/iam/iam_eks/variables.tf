variable "cluster_name" {
  type        = string
  description = "Nombre del EKS cluster"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags comunes para recursos IAM"
}
