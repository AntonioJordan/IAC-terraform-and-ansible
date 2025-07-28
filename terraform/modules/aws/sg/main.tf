resource "aws_security_group" "main_sg" {
  name        = var.name_sg
  description = var.description
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

}
