certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id"
DOMAIN = "*.myfiluet.com"
alb_name                   = "my-alb"
target_group_name          = "my-target-group"
target_group_port          = 80
health_check_interval      = 30
health_check_path          = "/health"
health_check_port          = "traffic-port"
health_check_protocol      = "HTTP"
health_check_timeout       = 5
healthy_threshold          = 3
unhealthy_threshold        = 3
TAGS = [{Environment =  "filuet-prod", Tier = "Prod", Role = "Web"}]