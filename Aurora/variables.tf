variable "region" {
  description = "The AWS region to deploy the Aurora cluster in"
  type        = string
  default     = "us-west-2"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "ecs_security_group_id" {
  description = "Security group ID of the ECS Fargate tasks"
  type        = string
}

variable "cluster_identifier" {
  description = "The identifier for the Aurora cluster"
  type        = string
}

variable "engine_version" {
  description = "The engine version for Aurora PostgreSQL"
  type        = string
  default     = "13.3"
}

variable "master_username" {
  description = "The master username for the Aurora cluster"
  type        = string
}

variable "master_password" {
  description = "The master password for the Aurora cluster"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "The name of the initial database"
  type        = string
}

variable "instance_class" {
  description = "The instance class for the Aurora instances"
  type        = string
  default     = "db.r5.large"
}

variable "replica_count" {
  description = "Number of read replicas"
  type        = number
  default     = 1
}

variable "db_subnet_group_name" {
  description = "The name of the existing DB subnet group"
  type        = string
}
