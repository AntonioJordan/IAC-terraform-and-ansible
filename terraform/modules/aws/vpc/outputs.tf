output "vpc_id"             { value = aws_vpc.main.id }
output "public_subnet_ids"  { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
output "vpc_endpoints" {
  value = {
    s3           = aws_vpc_endpoint.s3.id
    dynamodb     = aws_vpc_endpoint.dynamodb.id
    eks          = aws_vpc_endpoint.iface["eks"].id
    sts          = aws_vpc_endpoint.iface["sts"].id
    ssm          = aws_vpc_endpoint.iface["ssm"].id
    ssmmessages  = aws_vpc_endpoint.iface["ssmmessages"].id
    ec2messages  = aws_vpc_endpoint.iface["ec2messages"].id
  }
}
