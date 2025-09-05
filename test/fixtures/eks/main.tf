provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source = "../../../../terraform/modules/aws/eks"

  # Mock values
  name             = "test-eks"
  cluster_role_arn = "arn:aws:iam::111122223333:role/EKSClusterRole"
  node_role_arn    = "arn:aws:iam::111122223333:role/EKSNodeRole"
  private_subnets  = ["subnet-aaaaaa", "subnet-bbbbbb"]
  instance_type    = "t3.small"

  desired = 1
  max     = 2
  min     = 1

  tags_eks = {
    Environment = "test"
    Project     = "terratest"
  }
}

# Outputs to be validated in tests
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority" {
  value = module.eks.cluster_certificate_authority
}

output "node_group_name" {
  value = module.eks.node_group_name
}
