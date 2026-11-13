
resource "aws_ecr_repository" "app" {
  name                 = "aws-challenge"
  image_tag_mutability = "MUTABLE"
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "aws-challenge"
    Environment = var.environment
    Application = "java-spring-boot"
    Project     = var.project_name
  }
}
