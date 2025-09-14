resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name            = var.container_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1

  network_configuration {
    subnets = var.subnets
    security_groups = [aws_security_group.allow_traffic_to_container.id]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  launch_type = "FARGATE"

  tags = var.tags
}

resource "aws_ecs_task_definition" "service" {
  family = "service"

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      cpu       = 128
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = var.tags
}

resource "aws_security_group" "allow_traffic_to_container" {
  name        = "${var.cluster_name}-sg"
  description = "Minimal ECS security group."
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_ipv4" {
  security_group_id = aws_security_group.allow_traffic_to_container.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.container_port
  ip_protocol       = "-1"
  to_port           = var.container_port
}

resource "aws_vpc_security_group_ingress_rule" "allow_ipv6" {
  security_group_id = aws_security_group.allow_traffic_to_container.id
  cidr_ipv6         = "::/0"
  from_port         = var.container_port
  ip_protocol       = "-1"
  to_port           = var.container_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_egress" {
  security_group_id = aws_security_group.allow_traffic_to_container.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}