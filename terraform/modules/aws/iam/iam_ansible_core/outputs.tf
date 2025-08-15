output "ansible_instance_role_arn" {
  value = aws_iam_role.ansible_core.arn
}

output "ansible_instance_profile_arn" {
  value = aws_iam_instance_profile.ansible_core.arn
}

output "ansible_control_user_arn" {
  value = aws_iam_user.ansible_control.arn
}

output "ansible_control_policy_arn" {
  value = aws_iam_policy.ansible_control_min.arn
}

output "ansible_control_access_key_id" {
  value = aws_iam_access_key.ansible_control.id
}

output "ansible_control_secret_access_key" {
  value     = aws_iam_access_key.ansible_control.secret
  sensitive = true
}
