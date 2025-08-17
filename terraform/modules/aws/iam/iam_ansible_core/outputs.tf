output "role_arn" {
  value = aws_iam_role.ansible_core_role.arn
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ansible_core_profile.name
}
