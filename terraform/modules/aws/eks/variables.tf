variable "name" { type = string }
variable "cluster_role_arn" { type = string }
variable "node_role_arn" { type = string }
variable "private_subnets" { type = list(string) }
variable "instance_type" { type = string }
variable "desired" { type = number }
variable "min" { type = number }
variable "max" { type = number }
variable "tags_eks" {
  type    = map(string)
  default = {}
}