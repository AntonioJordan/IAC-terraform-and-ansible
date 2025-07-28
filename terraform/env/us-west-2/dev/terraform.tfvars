instance_type = "t3.micro"

cidr_block     = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
azs            = ["us-west-2a", "us-west-2b"]
tags = {
  Name = "vpc-dev"
  Env  = "dev"
}

