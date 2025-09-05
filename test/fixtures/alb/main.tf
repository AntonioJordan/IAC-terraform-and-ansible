provider "aws" {
  region = "us-east-1"
}

module "alb" {
  source = "../../../terraform/modules/aws/alb"

  # Mock values
  name_alb          = "test-alb"
  vpc_id            = "vpc-123456"
  security_group_id = "sg-123456"
  public_subnets    = ["subnet-111111", "subnet-222222"]

  tags = {
    Env = "test"
  }
}

output "alb_dns_name" {
  value = module.alb.this_lb_dns_name
}
