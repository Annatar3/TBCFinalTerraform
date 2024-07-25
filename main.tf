terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.REGION
}

module "main" {
  source = "./VPC"
  ENVIRONMENT_NAME = var.ENVIRONMENT_NAME
  REGION = var.REGION
  CIDR = var.CIDR
  TAGS = var.VPC_TAGS
  # depends_on          = [ module.ecr_module ]
}

module "ecr_module" {
  source              = "./ECR"
  ecr_repository_name = var.ecr_repository_name
  ENVIRONMENT_NAME = var.ENVIRONMENT_NAME
  TAGS = var.ECR_TAGS
}

module "alb_module" {
  source = "./ALB"
  TAGS                        = var.ALB_TAGS
  alb_name                    = var.alb_name
  DOMAIN                      = var.DOMAIN
  target_group_name           = var.target_group_name
  target_group_port           = var.target_group_port
  health_check_interval       = var.health_check_interval
  health_check_path           = var.health_check_path
  health_check_port           = var.health_check_port
  health_check_protocol       = var.health_check_protocol
  health_check_timeout        = var.health_check_timeout
  healthy_threshold           = var.healthy_threshold
  unhealthy_threshold         = var.unhealthy_threshold
  depends_on                  = [ module.main ]
}

module "ecs_module" {
  source = "./ECS"
  ENVIRONMENT_NAME            = var.ENVIRONMENT_NAME
  ecs_cluster_name            = var.ecs_cluster_name
  ecr_repository_name         = module.ecr_module.ecr_repository_name
  task_definition_family      = var.task_definition_family
  task_definition_compatibilities = var.task_definition_compatibilities
  task_definition_cpu         = var.task_definition_cpu
  task_definition_memory      = var.task_definition_memory
  container_name              = var.container_name
  volume_name                 = var.volume_name
  ecs_service_name            = var.ecs_service_name
  target_group_arn            = module.alb_module.target_group_arn
  alb_security_group_id       = module.alb_module.alb_security_group_id
  depends_on                  = [ module.alb_module ]
}



module "redis" {
  source           = "./Redis"
  port             = var.redis_port
  cluster_id       = var.redis_cluster_id
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_cache_nodes
  vpc_name         = module.main.vpc_name
  depends_on       = [module.main]
}

module "backend_cloudfront" {
  source                  = "./CloudfrontECS"
  ENVIRONMENT_NAME = var.ENVIRONMENT_NAME
  CF_REGION = var.CF_REGION
  DOMAIN = var.DOMAIN
  ALIAS_CF = var.ALIAS_CF
  TAGS = var.CF_TAGS
  ALB_DOMAIN = module.alb_module.alb_dns_name

}

module "s3_bucket" {
  source      = "./S3"
  bucket_name = var.bucket_name
}

# module "s3_cloudfront" {
#   source              = "./CloudfrontS3"
#   bucket_name         = var.bucket_name
#   default_root_object = var.default_root_object
#   depends_on          = [module.s3_bucket]
# }

module "rds" {
  source                 = "./RDS"
  ENVIRONMENT_NAME       = var.ENVIRONMENT_NAME
  TAGS                   = var.RDS_TAGS
  IDENTIFIER             = var.rds_identifier
  ENGINE                 = var.rds_engine
  ENGINE_VERSION         = var.rds_engine_version
  DB_INSTANCE_TYPE       = var.rds_instance_type
  MIN_ALLOCATED_STORAGE  = var.rds_min_allocated_storage
  MAX_ALLOCATED_STORAGE  = var.rds_max_allocated_storage
  STORAGE_TYPE           = var.rds_storage_type
  RDS_SG                 = var.rds_security_group_ids
  DB_USERNAME            = var.rds_username
  Password               = var.rds_password
  vpc_name               = module.main.vpc_name
  CIDR                   = var.CIDR
  depends_on             = [module.main]
}