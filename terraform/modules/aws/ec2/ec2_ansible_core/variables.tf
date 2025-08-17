variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "iam_instance_profile" {
  type = string
}

variable "key_name" {
  type = string
}

variable "tags_ansible_core" {
  type    = map(string)
  default = {}
}

variable "region" {
  type = string
}

variable "repo_url" {
  type = string
}

variable "inventory_rel_path" {
  type = string
}

variable "ansible_secret_blob" {
  type = string
  sensitive = true
}
