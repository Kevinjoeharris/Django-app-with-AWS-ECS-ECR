
provider "aws" {
  region = "us-east-1"
}

# Default VPC + Subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# Security Group for ECS tasks
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-django-sg"
  description = "Allow HTTP to ECS tasks"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ECS Cluster
resource "aws_ecs_cluster" "django_cluster" {
  name = "django-cluster"
}


# ECS Task Definition
resource "aws_ecs_task_definition" "django_task" {
  family                   = "django-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  # Use existing IAM role
  execution_role_arn = "arn:aws:iam::940743193916:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "django"
      image     = "940743193916.dkr.ecr.us-east-1.amazonaws.com/django-ecs-ecr"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}


# ECS Service
resource "aws_ecs_service" "django_service" {
  name            = "django-service"
  cluster         = aws_ecs_cluster.django_cluster.id
  task_definition = aws_ecs_task_definition.django_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
