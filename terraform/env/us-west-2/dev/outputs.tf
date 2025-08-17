# --- EKS ---
output "eks_cluster_endpoint" {
  description = "Endpoint del cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca" {
  description = "CA del cluster EKS"
  value       = module.eks.cluster_certificate_authority
}

# --- ALB ---
output "alb_dns_name" {
  description = "DNS del Application Load Balancer"
  value       = module.alb.dns_name
}

output "alb_arn" {
  description = "ARN del Application Load Balancer"
  value       = module.alb.arn
}

# --- Ansible Core ---
output "ansible_core_id" {
  description = "ID de la instancia Ansible Core"
  value       = module.ec2_ansible_core.ansible_core_id
}

output "ansible_core_private_ip" {
  description = "IP privada de Ansible Core"
  value       = module.ec2_ansible_core.ansible_core_private_ip
}
