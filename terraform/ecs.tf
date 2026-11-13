
# ==========================================
# 1. ECS CLUSTER
# ==========================================

resource "aws_ecs_cluster" "main" {
  name = "aws-challenge-cluster"

  tags = {
    Name = "aws-challenge-cluster"
  }
}

# ==========================================
# 2. IAM EXECUTION ROLE
# ==========================================

resource "aws_iam_role" "ecs_execution" {
  name = "aws-challenge-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role = aws_iam_role.ecs_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ==========================================
# 3. CLOUDWATCH LOGS
# ==========================================

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/aws-challenge"
  retention_in_days = 7

  tags = {
    Name = "aws-challenge-logs"
  }
}

# ==========================================
# 4. TASK DEFINITION
# ==========================================

resource "aws_ecs_task_definition" "app" {
  family                   = "aws-challenge-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "aws-challenge"
      image     = "${aws_ecr_repository.app.repository_url}:1.0"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution
  ]

  tags = {
    Name = "aws-challenge-task"
  }
}

# ==========================================
# 5. ECS SERVICE
# ==========================================

resource "aws_ecs_service" "app" {
  name            = "aws-challenge-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn

  desired_count = 1
  launch_type   = "FARGATE"

  health_check_grace_period_seconds = 120

  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "aws-challenge"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.http,
    aws_iam_role_policy_attachment.ecs_execution
  ]

  tags = {
    Name = "aws-challenge-service"
  }
}
