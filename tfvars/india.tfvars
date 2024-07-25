## AWS VPC
ENVIRONMENT_NAME = "final-prod"
REGION = "us-east-1"
CIDR   = "10.100.0.0/16"
VPC_TAGS = [{Environment =  "final-prod", Tier = "Prod", Role = "General"}]

# Value for ECR
ecr_repository_name = "tbcfinal-prod"
ECR_TAGS = [{Environment =  "tbcfinal-prod", Tier = "Prod", Role = "Web"}]


# Valuye for Redis
redis_port = 6379
redis_cluster_id = "tbcfinal-prod-redis-cluster"
redis_node_type = "cache.t3.micro"
redis_num_cache_nodes = 1


# Value for CloudFront
CF_REGION = "us-east-1"
ALIAS_CF = ["kacajuja.site"]
CF_TAGS = [{Environment =  "tbcfinal-prod", Tier = "Prod", Role = "Web"}]
ALB_DOMAIN = "filuet-prod-alb-666844756.eu-central-1.elb.amazonaws.com"


# Value for S3
bucket_name = "tbcfinal-prod-frontend"


# Value for RDS
RDS_TAGS       = [{Environment =  "tbcfinal-prod", Tier = "Prod", Role = "Sql"}]
rds_identifier = "tbcfinal-prod-db"
rds_engine = "sqlserver-ex"
rds_engine_version = "15.00.4073.23.v1"
rds_instance_type = "db.t3.micro"
rds_min_allocated_storage = 20
rds_max_allocated_storage = 30
rds_storage_type = "gp2"
rds_security_group_ids = []
rds_username = "admin"
rds_password = "Paroli1!"


##ECS Variables
task_definition_family    = "tbcfinal-td"
task_definition_compatibilities = ["FARGATE"]
task_definition_cpu       = 2048
task_definition_memory    = 4096
container_name            = "tbcfinal"
container_port            = 80
host_port                 = 80
volume_name               = "my-volume"
ecs_cluster_name          = "tbcfinal-prod"
ecs_service_name          = "tbcfinal"


##ALB Variables
ALB_TAGS                  = [{Environment =  "tbcfinal-prod", Tier = "Prod", Role = "Web"}]
alb_name                  = "tbcfinal-prod-alb"
DOMAIN                    = "kacajuja.site"
target_group_name         = "tbcfinal-prod-tg"
certificate_arn           = "arn:aws:acm:us-east-1:637423453796:certificate/f5e35126-9982-4e01-b759-f8a1d780b298"
health_check_interval     = 30
health_check_path         = "/"
health_check_port         = "traffic-port"
health_check_protocol     = "HTTP"
health_check_timeout      = 10
healthy_threshold         = 10
unhealthy_threshold       = 10
target_group_port         = 80
