output "eks_cluster_role_arn" {
  value       = aws_iam_role.eks_cluster_role.arn
  description = "ARN del IAM Role para el EKS Cluster"
}

output "eks_node_role_arn" {
  value       = aws_iam_role.eks_node_role.arn
  description = "ARN del IAM Role para los nodos EKS"
}
