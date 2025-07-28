
# EC2
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "tags_ec2" {
  type    = map(string)
  default = {}
}

# sg
variable "name" {
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
variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  default = {}
}

# asg
variable "name_asg" {
  type = string
}

variable "tags_asg" {
  type    = map(string)
  default = {}
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
