data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["final-prod"]
  }
}

# data "aws_subnets" "main" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.main.id]
#   }
# }

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["*web-private*"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

resource "aws_ecs_cluster" "ecs" {
  name = var.ecs_cluster_name
}

data "aws_ecr_repository" "ecr" {
  name = var.ecr_repository_name
}

data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "service" {
  family                   = var.task_definition_family
  requires_compatibilities = var.task_definition_compatibilities
  network_mode             = "awsvpc"
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  execution_role_arn       = data.aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = data.aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${data.aws_ecr_repository.ecr.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "${var.ENVIRONMENT_NAME}-ecs-sg"
  description = "Allow traffic only from ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }
    ingress {
    from_port       = "443"
    to_port         = "443"
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}

