# Fetch VPC and Public Subnet data
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["final-prod"]
  }
}

data "aws_subnets" "web-private" {
  filter {
    name   = "tag:Name"
    values = ["*web-public*"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

#Create a ALB-external
resource "aws_lb" "alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  internal           = false

  subnets         = data.aws_subnets.web-private.ids
  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Name = var.alb_name
    Environment = var.TAGS[0].Environment
    Tier = var.TAGS[0].Tier
    Role = var.TAGS[0].Role
  }
}

#-------------- Attach Target Group to ALB Listener ---------------

#Certificate
data "aws_acm_certificate" "certificate_issued" {
  domain   = var.DOMAIN
  statuses = ["ISSUED"]
}

# Attach API Target Group to External-ALB Listener
resource "aws_lb_listener" "target-group-listener-https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.certificate_issued.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No match found"
      status_code  = "503"  
    }
  }
}

resource "aws_lb_listener" "target-group-listener-http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      port        = "443"
      protocol    = "HTTPS"
    }
  }
}

resource "aws_lb_target_group" "armenia_target_group" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
  target_type = "ip"
  deregistration_delay= 10
  # health_check {
  #   interval            = var.health_check_interval
  #   path                = var.health_check_path
  #   port                = var.health_check_port
  #   protocol            = var.health_check_protocol
  #   timeout             = var.health_check_timeout
  #   healthy_threshold   = var.healthy_threshold
  #   unhealthy_threshold = var.unhealthy_threshold
    
  # }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow traffic from CloudFront"
  vpc_id      = data.aws_vpc.main.id

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
#--------------- ALB listener Rules ------------------

# ALB rule
resource "aws_lb_listener_rule" "armenia_host_based" {
  listener_arn = aws_lb_listener.target-group-listener-https.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.armenia_target_group.arn
  }

  condition {
    host_header {
      values = ["kacajuja.site"]
    }
  }
  tags = {
    Name = "final-prod"
  }
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.armenia_target_group.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}
