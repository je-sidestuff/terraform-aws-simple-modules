output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.minimal_fargate_task.cluster_name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = module.minimal_fargate_task.service_name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = module.minimal_fargate_task.task_definition_arn
}

output "security_group_id" {
  description = "ID of the security group created for the container"
  value       = module.minimal_fargate_task.security_group_id
}

output "load_balancer_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the load balancer"
  value       = module.alb.zone_id
}