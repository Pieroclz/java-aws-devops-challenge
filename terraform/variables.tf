
variable "aws_region" {
  description = "Region de AWS para desplegar infraestructura"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "java-aws-devops-challenge"
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}
