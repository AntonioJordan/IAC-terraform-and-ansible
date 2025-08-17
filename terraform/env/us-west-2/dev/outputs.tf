# --- VPC ---
output "vpc_id" {
  description = "ID de la VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Subnets públicas"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Subnets privadas"
  value       = module.vpc.private_subnet_ids
}

# --- Seguridad ---
output "security_group_id" {
  description = "ID del Security Group principal"
  value       = aws_security_group.main.id
}

# --- EKS ---
output "eks_cluster_name" {
  description = "Nombre del cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint del cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca" {
  description = "Certificado CA del cluster EKS"
  value       = module.eks.cluster_certificate_authority
}

# --- EC2 Ansible Core ---
output "ansible_core_instance_id" {
  description = "ID de la instancia EC2 de Ansible Core"
  value       = module.ec2_ansible_core.instance_id
}

output "ansible_core_private_ip" {
  description = "IP privada de Ansible Core"
  value       = module.ec2_ansible_core.private_ip
}

# --- ALB ---
output "alb_dns_name" {
  description = "DNS público del ALB"
  value       = module.alb.dns_name
}

output "alb_arn" {
  description = "ARN del ALB"
  value       = module.alb.arn
}
