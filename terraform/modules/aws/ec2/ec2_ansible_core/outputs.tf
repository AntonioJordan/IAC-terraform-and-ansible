output "ansible_controller_id" {
  description = "ID de la instancia Ansible Controller"
  value       = aws_instance.ansible_controller.id
}

output "ansible_controller_public_ip" {
  description = "IP pública de la instancia Ansible Controller"
  value       = aws_instance.ansible_controller.public_ip
}

output "ansible_controller_private_ip" {
  description = "IP privada de la instancia Ansible Controller"
  value       = aws_instance.ansible_controller.private_ip
}

output "ansible_controller_arn" {
  description = "ARN de la instancia Ansible Controller"
  value       = aws_instance.ansible_controller.arn
}
