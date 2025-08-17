# --- VPC ---
name_vpc        = "dev-vpc"
cidr_block      = "10.0.0.0/16"
region          = "us-west-2"
azs             = ["us-west-2a", "us-west-2b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

tags = {
  Env     = "dev"
  Project = "eks-cluster"
}

# --- EKS ---
eks_name          = "dev-eks"
eks_instance_type = "t3.micro"
eks_desired       = 2
eks_min           = 1
eks_max           = 2

# --- EC2 Ansible Core ---
instance_type = "t3.micro"
key_name      = "mi-keypair" # Debe existir en AWS

tags_ansible_core = {
  Name    = "ansible-core"
  Env     = "dev"
  Project = "eks-cluster"
}

# --- IAM para Ansible Core ---
iam_control_role_name             = "ansible-core-role"
iam_control_instance_profile_name = "ansible-core-profile"

# --- KMS ---
ansible_secret = "clave-super-secreta"

# --- ALB ---
name_alb = "dev-alb"

# --- Seguridad ---
my_ip = "80.24.35.17/32"
