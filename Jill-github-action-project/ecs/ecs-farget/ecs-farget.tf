# resource "aws_acm_certificate" "example" {
#   domain_name       = "clovisjillsshoesstore.link"
#   validation_method = "DNS" # Could also be "EMAIL"

#   tags = {
#     Name = "example-certificate"
#   }
# }

# variable "domain_name" {
#   description = "The domain name for which the ACM certificate will be issued"
#   type        = string
#   default     = "clovisjillsshoesstore.link"
# }

# resource "aws_subnet" "ecs_subnet2"{
#   vpc_id     = data.aws_vpc.default.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "ecs_subnet2"
#   }
# }

# resource "aws_subnet" "ecs_subnet"{
#   vpc_id     = data.aws_vpc.default.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "ecs_subnet"
#   }
# }

resource "aws_ecs_cluster" "example" {
  name = "example-cluster"
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound traffic on HTTP/HTTPS for ALB"
  vpc_id      = data.aws_vpc.default.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow traffic from ALB to ECS services"
  vpc_id      = data.aws_vpc.default.id


  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-043b4a536aefe0368", "subnet-070fd13aa046fa07c"]

  enable_deletion_protection = false

  tags = {
    Name = "example-alb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.example.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:563186190389:certificate/12f07c37-c84e-4b02-94d4-122715184de8"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 3000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path = "/health"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "backend" {
  name     = "backend-tg"
  port     = 5000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path = "/health"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

# resource "aws_lb_target_group" "backend_tg" {
#   name     = "backend-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
#   target_type = "ip"  # Change this to "ip"
#   health_check {
#     ...
#   }
# }

resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "shucknite/use-this-one-f:latest" # Replace with frontend image
      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
      }]
    }
  ])
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    { 
      name      = "backend"
      image     = "shucknite/use-this-one-b:latest" # Replace with backend image
      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
      }]
    }
  ])
}

resource "aws_ecs_service" "frontend" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         =  ["subnet-043b4a536aefe0368", "subnet-070fd13aa046fa07c"]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 3000
  }
  depends_on = [ aws_ecs_cluster.example, aws_lb_listener.https ]
}



resource "aws_ecs_service" "backend" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = ["subnet-043b4a536aefe0368", "subnet-070fd13aa046fa07c"]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 5000
  }
 depends_on = [ aws_ecs_cluster.example, aws_lb_listener.https ]
}

resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# resource "aws_route53_record" "example" {
#   zone_id = aws_route53_zone.example.zone_id
#   name    = "clovisjillsshoesstore.link"
#   type    = "A"

#   alias {
#     name                   = aws_lb.example.dns_name
#     zone_id                = aws_lb.example.zone_id
#     evaluate_target_health = true
#   }
# }

# resource "aws_route53_zone" "example" {
#   name = "clovisjillsshoesstore.link"
# }

# Data source for the default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source for default subnets
# data "aws_subnet_ids" "default" {
#   vpc_id = data.aws_vpc.default.id
#   filter {
#     name   = "tag:Name"
#     values = ["default-subnet1"]
#   }
# }

# data "aws_subnets" "default_vpc_subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AmazonECSTaskExecutionRolePolicy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Optional: Additional policies if required for access to other AWS services (e.g., Secrets Manager or SSM)
resource "aws_iam_role_policy_attachment" "ecs_task_extra_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess" # Example for SSM access
}


