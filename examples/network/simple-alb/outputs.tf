output "alb_arn" {
  value       = module.alb.arn
  description = "The ARN of the load balancer."
}

output "alb_dns_name" {
  value       = module.alb.dns_name
  description = "The DNS name of the load balancer."
}

output "http_listener_arn" {
  value       = module.alb.http_listener_arn
  description = "The ARN of the HTTP listener."
}
