output "arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics."
  value       = aws_lb.main.arn_suffix
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.main.dns_name
}

output "http_to_https_listener_arn" {
  description = "ARN of the HTTP to HTTPS listener"
  value       = try(aws_lb_listener.main[0].arn, null)
}

output "security_group" {
  description = "Security group ID of the Application Load Balancer"
  value       = try(module.sg[0].security_group_id, null)
}

output "zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)"
  value       = aws_lb.main.zone_id
}
