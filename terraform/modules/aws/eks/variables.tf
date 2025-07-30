variable "name" {}
variable "cluster_role_arn" {}
variable "node_role_arn" {}
variable "subnets" { type = list(string) }
variable "instance_type" {}
variable "desired" {}
variable "min" {}
variable "max" {}
