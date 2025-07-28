variable "name_asg" {
  type = string
}

variable "instance_type" {
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
