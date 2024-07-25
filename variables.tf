### VPC ###
variable "ENVIRONMENT_NAME" {
  type = string
}

variable "REGION" {
  type = string
}

variable "CIDR" {
  type = string
}

variable "VPC_TAGS" {
    type = list
}




### ECR ###
variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "ECR_TAGS" {
    type = list
}


### Redis ###
variable "redis_port" {
  description = "The port Redis listens on"
  type        = number
}

variable "redis_cluster_id" {
  description = "The ID of the Redis cluster"
  type        = string
}

variable "redis_node_type" {
  description = "The node type of the Redis cluster"
  type        = string
}

variable "redis_num_cache_nodes" {
  description = "The number of cache nodes in the Redis cluster"
  type        = number
}


### CloudFront ###
variable "CF_REGION" {
  type        = string
}

variable "ALIAS_CF" {
  type = list(any)
}

variable "CF_TAGS" {
    type = list
}

# variable "ALB_DOMAIN" {
#   description = "The domain name of ALB"
#   type        = string
# }


### S3 for Static content (CloudFront) ###
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

### RDS ###
variable "RDS_TAGS" {
    type = list
}

variable "rds_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "rds_engine" {
  description = "The engine type for the RDS instance"
  type        = string
}

variable "rds_engine_version" {
  description = "The engine version for the RDS instance"
  type        = string
}

variable "rds_instance_type" {
  description = "The instance type for the RDS instance"
  type        = string
}

variable "rds_min_allocated_storage" {
  description = "The minimum allocated storage for the RDS instance"
  type        = number
}

variable "rds_max_allocated_storage" {
  description = "The maximum allocated storage for the RDS instance"
  type        = number
}

variable "rds_storage_type" {
  description = "The storage type for the RDS instance"
  type        = string
}

variable "rds_security_group_ids" {
  description = "The security group IDs for the RDS instance"
  type        = list(string)
}

variable "rds_username" {
  description = "The username for the RDS instance"
  type        = string
}

variable "rds_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}



### ALB ###

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "DOMAIN" {
  description = "alb domain"
  type        = string
}

variable "ALB_TAGS" {
    type = list
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
}

variable "health_check_interval" {
  description = "Health check interval for the target group"
  type        = number
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
}

variable "health_check_port" {
  description = "Health check port for the target group"
  type        = string
}

variable "health_check_protocol" {
  description = "Health check protocol for the target group"
  type        = string
}

variable "health_check_timeout" {
  description = "Health check timeout for the target group"
  type        = number
}

variable "healthy_threshold" {
  description = "Healthy threshold for the target group"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold for the target group"
  type        = number
}


### ECS ###

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}


variable "task_definition_family" {
  description = "Family name of the ECS task definition"
  type        = string
}

variable "task_definition_compatibilities" {
  description = "Compatibilities of the ECS task definition"
  type        = list(string)
}

variable "task_definition_cpu" {
  description = "CPU units for the ECS task definition"
  type        = number
}

variable "task_definition_memory" {
  description = "Memory for the ECS task definition"
  type        = number
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_port" {
  description = "The port Redis listens on"
  type        = number
}

variable "volume_name" {
  description = "Volume name for the ECS task definition"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}