
output "aws_region" {
  description = "Region AWS utilizada"
  value       = var.aws_region
}

output "ecr_repository_name" {
  description = "Nombre del repositorio ECR"
  value       = aws_ecr_repository.app.name
}

output "ecr_repository_url" {
  description = "URL del repositorio ECR"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nombre del servicio ECS"
  value       = aws_ecs_service.app.name
}

output "application_url" {
  description = "Endpoint publico de la API"
  value       = "http://${aws_lb.app.dns_name}/api/hello"
}

output "health_check_url" {
  description = "Endpoint publico de salud"
  value       = "http://${aws_lb.app.dns_name}/actuator/health"
}
