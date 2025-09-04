resource "aws_launch_template" "eks_nodes" {
  name_prefix = "${var.name}-lt"

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      { Name = "${var.name}-node" },
      var.tags_eks
    )
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
}

resource "aws_kms_key" "eks" {
  description             = "CMK para cifrado de Kubernetes Secrets en EKS"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

#tfsec:ignore:aws-eks-enable-control-plane-logging
resource "aws_eks_cluster" "cluster" {
  name     = var.name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_public_access  = false
    endpoint_private_access = true
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.eks.arn
    }
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [vpc_config]
  }
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = var.desired
    max_size     = var.max
    min_size     = var.min
  }

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]

  lifecycle {
    prevent_destroy = false
  }

  tags = var.tags_eks
}
