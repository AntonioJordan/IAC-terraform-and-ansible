resource "aws_eks_cluster" "cluster" {
  name     = var.name
  role_arn = var.cluster_role_arn
  vpc_config {
    subnet_ids = var.subnets
  }
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnets
  instance_types  = [var.instance_type]
  scaling_config {
    desired_size = var.desired
    max_size     = var.max
    min_size     = var.min
  }
}
