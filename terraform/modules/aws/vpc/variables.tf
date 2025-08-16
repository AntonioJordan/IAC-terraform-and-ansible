variable "name_vpc" { type = string }
variable "cidr_block" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" {
  type = list(string)

  validation {
    condition     = length(var.public_subnets) == length(var.azs) && length(var.private_subnets) == length(var.azs)
    error_message = "Debe haber exactamente una subnet pública y una privada por AZ."
  }
}
variable "region" { type = string }
variable "tags" { 
  type    = map(string) 
  default = {} 
}
