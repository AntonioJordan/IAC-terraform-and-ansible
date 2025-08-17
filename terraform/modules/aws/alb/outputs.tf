output "dns_name" {
  description = "DNS público del ALB"
  value       = aws_lb.this.dns_name
}

output "arn" {
  description = "ARN del ALB"
  value       = aws_lb.this.arn
}
