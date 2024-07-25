## AWS VPC
ENVIRONMENT_NAME = "inevents-prod"
REGION = "ap-south-1"
CIDR   = "10.100.0.0/16"
VPC_TAGS = [{Environment =  "inevents-prod", Tier = "Prod", Role = "General"}]

# Value for ECR
ecr_repository_name = "filuet-prod-inevents"
ECR_TAGS = [{Environment =  "inevents-prod", Tier = "Prod", Role = "Web"}]


# Valuye for Redis
redis_port = 6379
redis_cluster_id = "inevents-prod-redis-cluster"
redis_node_type = "cache.t3.micro"
redis_num_cache_nodes = 1


# Value for CloudFront
CF_REGION = "us-east-1"
ALIAS_CF = ["in-events.myfiluet.com", "in-test-events.myfiluet.com"]
CF_TAGS = [{Environment =  "inevents-prod", Tier = "Prod", Role = "Web"}]



# Value for S3
bucket_name = "inevents-prod-frontend"


# Value for RDS
RDS_TAGS       = [{Environment =  "inevents-prod", Tier = "Prod", Role = "Sql"}]
rds_identifier = "inevents-prod-db"
rds_engine = "sqlserver-web"
rds_engine_version = "15.00.4073.23.v1"
rds_instance_type = "db.r5.large"
rds_min_allocated_storage = 20
rds_max_allocated_storage = 50
rds_storage_type = "gp3"
rds_security_group_ids = []
rds_username = "admin"
rds_password = "Paroli1!"


##ECS Variables
task_definition_family    = "inevents-td"
task_definition_compatibilities = ["FARGATE"]
task_definition_cpu       = 2048
task_definition_memory    = 4096
container_name            = "inevents"
container_port            = 80
host_port                 = 80
volume_name               = "my-volume"
ecs_cluster_name          = "inevents-prod"
ecs_service_name          = "inevents"


##ALB Variables
ALB_TAGS                  = [{Environment =  "inevets-prod", Tier = "Prod", Role = "Web"}]
alb_name                  = "inevents-prod-alb"
DOMAIN                    = "*.myfiluet.com"
target_group_name         = "inevents-prod-tg"
certificate_arn           = "arn:aws:acm:eu-central-1:058264546686:certificate/6d072c0f-2448-468e-aadc-08a2f3641a96"
health_check_interval     = 10
health_check_path         = "/health"
health_check_port         = "traffic-port"
health_check_protocol     = "HTTPS"
health_check_timeout      = 5
healthy_threshold         = 3
unhealthy_threshold       = 3
target_group_port         = 443
