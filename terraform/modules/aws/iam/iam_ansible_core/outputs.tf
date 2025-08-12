output "iam_instance_profile_name" {
  description = "Nombre del IAM Instance Profile para Ansible Core"
  value       = aws_iam_instance_profile.ansible_core.name
}

output "iam_role_name" {
  description = "Nombre del IAM Role para Ansible Core"
  value       = aws_iam_role.ansible_core.name
}
