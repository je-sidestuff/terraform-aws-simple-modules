output "arn" {
  value       = aws_lb.this.arn
  description = "The ARN of the load balancer."
}

output "dns_name" {
  value       = aws_lb.this.dns_name
  description = "The DNS name of the load balancer."
}

output "zone_id" {
  value       = aws_lb.this.zone_id
  description = "The canonical hosted zone ID of the load balancer (for Route53 alias records)."
}

output "target_group_arn" {
  value       = length(aws_lb_target_group.this) > 0 ? aws_lb_target_group.this[0].arn : null
  description = "The ARN of the load balancer target group."
}

output "http_listener_arn" {
  value       = length(aws_lb_listener.http) > 0 ? aws_lb_listener.http[0].arn : (length(aws_lb_listener.http_redirect) > 0 ? aws_lb_listener.http_redirect[0].arn : null)
  description = "The ARN of the HTTP listener (port 80), if enabled."
}

output "https_listener_arn" {
  value       = length(aws_lb_listener.https) > 0 ? aws_lb_listener.https[0].arn : null
  description = "The ARN of the HTTPS listener (port 443), if enabled."
}

output "url" {
  value       = var.create_dns_record && var.domain != null ? (var.enable_https ? "https://${var.domain}" : "http://${var.domain}") : null
  description = "The URL where the app may be reached, if DNS record was created."
}
