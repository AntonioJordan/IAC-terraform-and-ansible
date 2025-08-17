output "ansible_core_id" {
  description = "ID de la instancia Ansible Core"
  value       = aws_instance.this.id
}

output "ansible_core_private_ip" {
  description = "IP privada de la instancia Ansible Core"
  value       = aws_instance.this.private_ip
}
