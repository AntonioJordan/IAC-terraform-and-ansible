provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source = "../../../terraform/modules/aws/eks"

  name              = "mock-eks"
  cluster_role_arn  = "arn:aws:iam::123456789012:role/mock-eks-cluster-role"
  node_role_arn     = "arn:aws:iam::123456789012:role/mock-eks-node-role"
  private_subnets   = ["subnet-aaaa1111", "subnet-bbbb2222"]
  instance_type     = "t3.micro"
  desired           = 1
  max               = 2
  min               = 1

  tags_eks = {
    Env = "test"
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority" {
  value = module.eks.cluster_certificate_authority
}

output "node_group_name" {
  value = module.eks.node_group_name
}
