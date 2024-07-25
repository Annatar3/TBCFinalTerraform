variable "ENVIRONMENT_NAME" {
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
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
  description = "Memory for the ECS task definition"
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
