output "cluster_endpoint" {
  description = "Endpoint del EKS"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority" {
  description = "CA del EKS"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "node_group_name" {
  description = "Nombre del node group"
  value       = aws_eks_node_group.nodes.id
}
