resource "aws_kms_key" "ansible" {
  description         = var.kms_description
  enable_key_rotation = var.enable_key_rotation
}

resource "aws_kms_alias" "ansible" {
  name          = var.kms_name
  target_key_id = aws_kms_key.ansible.key_id
}
