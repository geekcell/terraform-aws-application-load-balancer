output "arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.basic-example.arn
}

output "arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics."
  value       = module.basic-example.arn_suffix
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.basic-example.dns_name
}
