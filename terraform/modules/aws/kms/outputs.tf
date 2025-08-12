output "kms_key_id" {
  value = aws_kms_key.ansible.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.ansible.arn
}

output "kms_alias_arn" {
  value = aws_kms_alias.ansible.arn
}
