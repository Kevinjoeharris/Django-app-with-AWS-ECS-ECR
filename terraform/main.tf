provider "aws" {
  region = var.aws_region
}


# ECR Repository
resource "aws_ecr_repository" "django" {
  name = var.django-ecs-ecr
}


# Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "django-ecs-ecr-sg"
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


# ECS Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "django-ecs-ecr-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ECS Cluster
resource "aws_ecs_cluster" "django_cluster" {
  name = "django-ecs-ecr-cluster"
}


# ECS Task Definition
resource "aws_ecs_task_definition" "django_task" {
  family                   = "django-ecs-ecr-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name      = "django"
    image     = "${aws_ecr_repository.django.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 8000
      hostPort      = 8000
    }]
  }])
}


# ECS Service
resource "aws_ecs_service" "django_service" {
  name            = "django-ecs-ecr-service"
  cluster         = aws_ecs_cluster.django_cluster.id
  task_definition = aws_ecs_task_definition.django_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

# Jenkins Server
resource "aws_ec2_instance" "jenkins _server" {
  

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