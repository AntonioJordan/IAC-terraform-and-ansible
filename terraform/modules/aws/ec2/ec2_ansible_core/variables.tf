variable "ami"                   { type = string }
variable "instance_type"         { type = string  default = "t3.micro" }
variable "subnet_id"             { type = string }
variable "security_group_ids"    { type = list(string) }
variable "iam_instance_profile"  { type = string }
variable "key_name"              { type = string }
variable "tags_ansible_core"     { type = map(string) }
variable "region"                { type = string }
