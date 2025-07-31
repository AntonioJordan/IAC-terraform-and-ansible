resource "aws_vpc_endpoint" "s3" {
  vpc_id         = aws_vpc.main.id
  service_name   = "com.amazonaws.${var.region}.s3"
  route_table_ids = aws_route_table.private[*].id
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id         = aws_vpc.main.id
  service_name   = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = aws_route_table.private[*].id
}

resource "aws_vpc_endpoint" "eks" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.eks"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [var.eks_security_group_id]

  private_dns_enabled = true
}
