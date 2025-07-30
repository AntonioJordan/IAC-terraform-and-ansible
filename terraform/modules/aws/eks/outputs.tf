output "cluster_name" { value = aws_eks_cluster.cluster.name }
output "endpoint"     { value = aws_eks_cluster.cluster.endpoint }
output "node_group"   { value = aws_eks_node_group.nodes.id }
