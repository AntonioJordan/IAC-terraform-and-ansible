# Gateway endpoints
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id
  tags              = merge(var.tags, { Name = "${var.name_vpc}-vpce-s3" })
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id
  tags              = merge(var.tags, { Name = "${var.name_vpc}-vpce-dynamodb" })
}

# SG para Interface Endpoints
resource "aws_security_group" "vpc_interface_sg" {
  name        = "${var.name_vpc}-vpce-sg"
  description = "SG for VPC Interface Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress { 
    from_port = 443 
    to_port = 443 
    protocol = "tcp" 
    cidr_blocks = [aws_vpc.main.cidr_block] 
  }
  egress  { 
    from_port = 0   
    to_port = 0   
    protocol = "-1"  
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = merge(var.tags, { Name = "${var.name_vpc}-vpce-sg" })
}

locals {
  interface_services = {
    eks          = "com.amazonaws.${var.region}.eks"
    sts          = "com.amazonaws.${var.region}.sts"
    ssm          = "com.amazonaws.${var.region}.ssm"
    ssmmessages  = "com.amazonaws.${var.region}.ssmmessages"
    ec2messages  = "com.amazonaws.${var.region}.ec2messages"
    ecr_api      = "com.amazonaws.${var.region}.ecr.api"
    ecr_dkr      = "com.amazonaws.${var.region}.ecr.dkr"
    logs         = "com.amazonaws.${var.region}.logs"
    ec2          = "com.amazonaws.${var.region}.ec2"
  }
}

resource "aws_vpc_endpoint" "iface" {
  for_each            = local.interface_services
  vpc_id              = aws_vpc.main.id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_interface_sg.id]
  tags                = merge(var.tags, { Name = "${var.name_vpc}-vpce-${each.key}" })
}
